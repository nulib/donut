unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
  require 'active_fedora/rake_support'

  namespace :donut do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace']
    end

    desc 'Load test config'
    task :load_test_config do
      Rails.env = 'test'
      Settings.reload_from_files(
        Rails.root.join("config", "settings.yml").to_s,
        Rails.root.join("config", "settings.local.yml").to_s,
        Rails.root.join("config", "settings", "test.yml").to_s,
        Rails.root.join("config", "environments", "test.yml").to_s,
        Rails.root.join("config", "settings", "test.local.yml").to_s,
        Rails.root.join("config", "environments", "test.local.yml").to_s
      )
    end

    desc 'Seed the test environment and run specs'
    task :setup_and_specs do
      %w[
        donut:load_test_config
        db:setup
        zookeeper:upload
        zookeeper:create
        elasticsearch:init
        donut:rspec
      ].each { |task| Rake::Task[task].invoke }
    end

    desc 'Add admin role to the ENV[\'ADMIN_USER\']'
    task add_admin_role: :environment do
      if ENV['ADMIN_USER']
        u = User.find_by(username: ENV['ADMIN_USER'])
        if u.admin?
          puts "#{u} already an admin"
        else
          puts "Adding admin role to user #{u}"
          u.roles << Role.first_or_create(name: 'admin')
        end
      end
    end

    desc 'Seed the development environment'
    task seed: :environment do
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['zookeeper:upload'].invoke
      Rake::Task['zookeeper:create'].invoke
      Rake::Task['elasticsearch:init'].invoke
      ActiveRecord::Base.descendants.each(&:reset_column_information)
      Rake::Task['hyrax:default_collection_types:create'].invoke
      Rake::Task['hyrax:default_admin_set:create'].invoke if AdminSet.count.zero?
      Hyrax::PermissionTemplate.create!(source_id: AdminSet::DEFAULT_ID) if Hyrax::PermissionTemplate.count.zero?
      Rake::Task['hyrax:workflow:load'].invoke
      Rake::Task['s3:setup'].invoke
      # rubocop:disable Rails/SkipsModelValidations
      Sipity::Workflow.find_by(name: 'default').update_attribute :active, true
      Sipity::Workflow.find_by(name: 'one_step_mediated_deposit').update_attribute :active, false
      # rubocop:enable Rails/SkipsModelValidations
      if ENV['ADMIN_USER']
        User.find_or_create_by(username: ENV['ADMIN_USER'], email: ENV['ADMIN_EMAIL'])
        Rake::Task['donut:add_admin_role'].invoke
      end

      Rake::Task['donut:load'].invoke if ENV['SEED_FILE']
    end

    desc 'Run all Continuous Integration tests'
    task :ci do
      Rake::Task['donut:ci:rubocop'].invoke
      Rake::Task['donut:ci:rspec'].invoke
      Rake::Task['jasmine:ci'].invoke
    end

    namespace :ci do
      desc 'Execute Continuous Integration build'
      task :rspec do
        Rake::Task['docker:spec'].invoke
      end

      desc 'Run style checker'
      RuboCop::RakeTask.new(:rubocop) do |task|
        task.fail_on_error = true
      end
    end
  end
end
