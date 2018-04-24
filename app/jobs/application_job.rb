class ApplicationJob < ActiveJob::Base
  queue_as Hyrax.config.ingest_queue_name
end
