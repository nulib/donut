require 'active_job/queue_adapters/better_active_elastic_job_adapter'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveJob::QueueAdapters::BetterActiveElasticJobAdapter.send(:instance_variable_set, :@aws_credentials, Aws::SharedCredentials.new)
  end

  config.after(:suite) do
    ActiveJob::QueueAdapters::BetterActiveElasticJobAdapter.send(:instance_variable_set, :@aws_credentials, nil)
  end
end
