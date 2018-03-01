unless Rails.env.production?
  require 'docker_controller'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
  require 'active_fedora/rake_support'

  namespace :donut do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace']
    end

    namespace :server do
      desc 'Clean up the development stack'
      task :clean do
        DockerController.new(cleanup: true).down
      end

      desc 'Run the development stack in the foreground'
      task :dev do
        DockerController.new.start
      end

      desc 'Run the test stack in the foreground'
      task :test do
        DockerController.new(config: 'docker-compose.test.yml', cleanup: true).start
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
        DockerController.new(config: 'docker-compose.test.yml', cleanup: true).with_containers do
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
