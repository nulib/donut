namespace :donut do
  desc 'Load a seed file'
  task load: :environment do
    yaml = YAML.safe_load(open(ENV['SEED_FILE']).read, [Symbol])
    Donut::SeedDataService.load(yaml) do |klass, status|
      puts "Loading #{klass} #{status}"
    end
  end

  desc 'Dump admin sets and users to a file'
  task dump: :environment do
    puts YAML.dump Donut::SeedDataService.dump
  end
end
