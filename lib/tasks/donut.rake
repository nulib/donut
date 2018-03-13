unless Rails.env.production?
  require 'docker_controller'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
  require 'active_fedora/rake_support'

  namespace :donut do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace']
    end

    desc 'Add admin role to last user'
    task add_admin_role: :environment do
      u = User.last
      puts "Adding admin role to user #{u}"
      u.roles << Role.first_or_create(name: 'admin') unless u.admin?
    end

    namespace :db do
      desc 'Create only the database for the current environment'
      task create: :environment do
        require 'donut/database_creator'
        Donut::DatabaseCreator.create_only_current!
      end
    end

    desc 'Seed the development environment'
    task seed: :environment do
      Rake::Task['donut:db:create'].invoke
      Rake::Task['db:migrate'].invoke
      ActiveRecord::Base.descendants.each(&:reset_column_information)
      Rake::Task['hyrax:default_collection_types:create'].invoke
      Rake::Task['hyrax:default_admin_set:create'].invoke if AdminSet.count.zero?
      Hyrax::PermissionTemplate.create!(source_id: AdminSet::DEFAULT_ID) if Hyrax::PermissionTemplate.count.zero?
      Rake::Task['hyrax:workflow:load'].invoke
      Rake::Task['s3:setup'].invoke
      Sipity::Workflow.all.each { |wf| wf.update_attribute :active, true } # rubocop:disable Rails/SkipsModelValidations
      if ENV['ADMIN_USER']
        User.find_or_create_by(username: ENV['ADMIN_USER'], email: ENV['ADMIN_EMAIL'])
        Rake::Task['donut:add_admin_role'].invoke
      end
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
        Rails.env = 'test'
        DockerController.new(cleanup: true).start
      end
    end

    desc 'Run all Continuous Integration tests'
    task :ci do
      Rake::Task['donut:ci:rubocop'].invoke
      Rake::Task['donut:ci:rspec'].invoke
    end

    namespace :ci do
      desc 'Execute Continuous Integration build'
      task :rspec do
        Rails.env = 'test'
        DockerController.new(cleanup: true).with_containers do
          # rspec doesn't force us into test mode yet, so we have to do it ourselves
          Rake::Task['donut:db:create'].invoke
          Rake::Task['db:migrate'].invoke
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
