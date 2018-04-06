# override FileSetActor to add a file_set.reload
# https://github.com/samvera/hyrax/blob/master/app/actors/hyrax/actors/file_set_actor.rb
# otherwise characterization info being overritten in solr in dev environments
# rubocop:disable Metrics/AbcSize
Hyrax::Actors::FileSetActor.class_eval do
  # Adds a FileSet to the work using ore:Aggregations.
  # Locks to ensure that only one process is operating on the list at a time.
  def attach_to_work(work, file_set_params = {})
    acquire_lock_for(work.id) do
      file_set.reload
      # Ensure we have an up-to-date copy of the members association, so that we append to the end of the list.
      work.reload unless work.new_record?
      file_set.visibility = work.visibility unless assign_visibility?(file_set_params)
      work.ordered_members << file_set
      work.representative = file_set if work.representative_id.blank?
      work.thumbnail = file_set if work.thumbnail_id.blank?
      # Save the work so the association between the work and the file_set is persisted (head_id)
      # NOTE: the work may not be valid, in which case this save doesn't do anything.

      work.save
      Hyrax.config.callback.run(:after_create_fileset, file_set, user)
    end
  end
  alias_method :attach_file_to_work, :attach_to_work
  deprecation_deprecate attach_file_to_work: 'use attach_to_work instead'
end
# rubocop:enable Metrics/AbcSize
