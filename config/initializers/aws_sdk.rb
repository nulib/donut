if Settings.localstack
  # Use localstack for AWS services
  require 'docker/stack/localstack/endpoint_stub'
  Docker::Stack::Localstack::EndpointStub.stub_endpoints!
  if Settings.active_job&.queue_adapter.to_s == 'shoryuken'
    require 'shoryuken'
    require 'aws-sdk-sqs'
    Shoryuken.sqs_client = Aws::SQS::Client.new
  end
end
