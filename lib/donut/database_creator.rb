module Donut
  module DatabaseCreator
    module_function

    include ActiveRecord::Tasks

    def create_only_current!
      config = ActiveRecord::Base.configurations[Rails.env]
      DatabaseTasks.create config
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    end
  end
end
