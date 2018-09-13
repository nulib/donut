# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  begin
    require 'docker/stack/rake_task'

    def get_named_task(task_name)
      Rake::Task[task_name]
    rescue RuntimeError
      nil
    end

    namespace :docker do
      namespace(:dev)  { Docker::Stack::RakeTask.load_tasks }
      namespace(:test) { Docker::Stack::RakeTask.load_tasks(force_env: 'test', cleanup: true) }

      desc 'Spin up test stack and run specs'
      task :spec do
        Rake::Task['donut:load_test_config'].invoke
        Docker::Stack::Controller.new(cleanup: true).with_containers do
          Rake::Task['donut:setup_and_specs'].invoke
        end
      end
    end
  rescue LoadError
    Rails.logger.warn 'Docker rake tasks not loaded.'
  end
end
