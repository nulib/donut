class CharacterizeJob < ApplicationJob
  # Characterizes the file at 'filepath' if available, otherwise, pulls a copy from the repository
  # and runs characterization on that file.
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path
  def perform(file_set, file_id, filepath = nil)
    raise "#{file_set.class.characterization_proxy} was not found for FileSet #{file_set.id}" unless file_set.characterization_proxy?
    filepath = Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id) unless filepath && File.exist?(filepath)
    run_characterization_services(file_set.characterization_proxy, filepath)
    file_set.characterization_proxy.save!
    file_set.update_index
    file_set.parent.in_collections.each(&:update_index) if file_set.parent
    CreateDerivativesJob.perform_later(file_set, file_id, filepath)
  end

  private

    def run_characterization_services(object, source)
      Hydra::Works::CharacterizationService.run(object, source)
      Rails.logger.debug "Ran Hydra::Works::CharacterizationService on #{object.id} (#{object.mime_type})"
      Donut::CharacterizationService.run(object, source)
      Rails.logger.debug "Ran Donut::CharacterizationService on #{object.id} (#{object.mime_type})"
    end
end
