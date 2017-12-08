unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'solr_wrapper'   # necessary for rake_support to work
  require 'fcrepo_wrapper' # necessary for rake_support to work
  require 'rubocop/rake_task'
  require 'active_fedora/rake_support'

  namespace :donut do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace']
    end

    namespace :ci do
      desc 'Execute Continuous Integration build'
      task rspec: :environment do
        with_test_server do
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
