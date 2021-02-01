namespace :migration do
  desc 'Create work manifests and upload them to S3'
  task run: :environment do
    limit = ENV.fetch('EXPORT_LIMIT', 200_000).to_i
    puts "Exporting #{limit} DONUT manifests."
    Donut::MigrationService.run(limit)
    puts 'Manifest export complete.'
  end
end
