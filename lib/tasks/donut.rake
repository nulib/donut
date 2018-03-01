unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
  require 'active_fedora/rake_support'

  def start_containers(config: 'docker-compose.yml', cleanup: false)
    dc = Docker::Compose::Session.new(dir: Rails.root, file: config)
    begin
      Signal.trap('INT') { exit(0) }
      dc.up('fedora', 'solr', 'redis', 'minio', detached: block_given?)
      if block_given?
        sleep(20)
        yield
      end
    ensure
      dc.run!('down', v: cleanup)
    end
  end

  namespace :donut do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace']
    end

    namespace :server do
      desc 'Clean up the development stack'
      task :clean do
        Docker::Compose::Session.new(dir: Rails.root).run!('down', v: true)
      end

      desc 'Run the development stack in the foreground'
      task :dev do
        start_containers
      end

      desc 'Run the test stack in the foreground'
      task :test do
        start_containers(config: 'docker-compose.test.yml', cleanup: true)
      end
    end

    desc 'Run all Continuous Integration tests'
    task ci: :environment do
      Rake::Task['donut:ci:rubocop'].invoke
      Rake::Task['donut:ci:rspec'].invoke
    end

    namespace :ci do
      desc 'Execute Continuous Integration build'
      task rspec: :environment do
        start_containers(config: 'docker-compose.test.yml', cleanup: true) do
          Rake::Task['donut:rspec'].invoke
        end
      end

      desc 'Run style checker'
      RuboCop::RakeTask.new(:rubocop) do |task|
        task.fail_on_error = true
      end
    end
  end
end
