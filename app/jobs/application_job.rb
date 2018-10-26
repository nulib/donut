class ApplicationJob < ActiveJob::Base
  queue_as Hyrax.config.ingest_queue_name

  before_enqueue  { |job| job.transition_state('queued')   }
  before_perform { |job| job.transition_state('performing') }
  after_perform  { |job| job.transition_state('performed')  }

  def transition_state(state)
    CrappyStateMachine.transition(job_class: self.class.name,
                                  target_id: target_and_work[:target_id],
                                  job_id: job_id,
                                  work_id: target_and_work[:work_id],
                                  state: state)
  end

  private

    def target_and_work
      @target_and_work ||= ids_for(arguments.first.is_a?(String) ? ActiveFedora::Base.where(id: arguments.first).first : arguments.first)
    end

    def ids_for(target)
      case target
      when Image        then { target_id: target.id, work_id: target.id }
      when FileSet      then { target_id: target.id, work_id: target&.parent&.id }
      when JobIoWrapper then { target_id: target.file_set.id, work_id: target.file_set&.parent&.id }
      else { target_id: nil, work_id: nil }
      end
    end
end
