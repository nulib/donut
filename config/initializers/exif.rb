# job_runner = Module.new do
#   def perform(file_set, file_id, file_path = nil)
#     CreateExifTechnicalMetadataJob.perform_later(file_set, file_id, file_path = nil)
#     super
#   end
# end

# CharacterizeJob.include(job_runner)
