if Settings.localstack
  # Use localstack for AWS services
  require 'aws-sdk-lambda'
  require 'aws-sdk-s3'

  Aws.config.update(
    s3: {
      endpoint: Settings.aws.endpoint,
      access_key_id: 'minio',
      secret_access_key: 'minio123',
      force_path_style: true,
      region: 'us-east-1'
    }
  )

  if Settings.localstack.sqs
    require 'active_elastic_job'
    Rails.application.configure do
      config.active_job.queue_adapter = :active_elastic_job
      config.active_elastic_job.process_jobs = true
      config.active_elastic_job.aws_credentials = Aws::SharedCredentials.new
      config.active_elastic_job.secret_key_base = Rails.application.secrets[:secret_key_base]
      config.middleware.use(ActiveElasticJob::Rack::SqsMessageConsumer)
    end
  end
end
