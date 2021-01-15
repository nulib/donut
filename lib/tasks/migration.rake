namespace :migration do
  desc 'Create work manifests and upload them to S3'
  task run: :environment do
    limit = ENV.fetch('EXPORT_LIMIT', 200_000).to_i
    overwrite = ENV['OVERWRITE'] ? true : false
    Donut::MigrationService.run(limit, overwrite)
  end
end
