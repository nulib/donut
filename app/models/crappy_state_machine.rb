class CrappyStateMachine < ApplicationRecord
  class << self
    def trace(job_class:, job_id:, target_id:, work_id:)
      transition(job_class: job_class, job_id: job_id, target_id: target_id, work_id: work_id, state: 'performing')
      yield
      transition(job_class: job_class, job_id: job_id, target_id: target_id, work_id: work_id, state: 'performed')
    rescue StandardError
      transition(job_class: job_class, job_id: job_id, target_id: target_id, work_id: work_id, state: 'exception')
      raise
    end

    def transition(job_class:, job_id:, target_id:, work_id:, state:)
      Rails.logger.debug "CSM: (#{job_class.inspect}, #{target_id.inspect}) -> #{state}"
      return if work_id.nil?
      csm = where(job_class: job_class, target_id: target_id).first_or_initialize
      csm.update_attributes(job_id: job_id, work_id: work_id, state: state)
    end

    def work_status(work_id)
      { id: work_id, file_sets: {} }.tap do |result|
        where(work_id: work_id).order(:updated_at).each do |csm|
          value = { state: csm.state, at: csm.updated_at }
          if work_id == csm.target_id
            result[csm.job_class] = value
          else
            (result[:file_sets][csm.target_id] ||= {})[csm.job_class] = value
          end
        end
      end
    end

    def zombies
      where("(updated_at < :run_age AND state = 'performing') OR (updated_at < :queue_age AND state = 'enqueued')", run_age: 1.day.ago, queue_age: 1.week.ago)
    end
  end
end
