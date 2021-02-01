if Settings.localstack
  # Use localstack for AWS services
  require 'aws-sdk-s3'

  Aws.config.update(
    endpoint: Settings.aws.endpoint,
    access_key_id: 'minio',
    secret_access_key: 'minio123',
    region: 'us-east-1'
  )

  Aws.config[:s3] = { force_path_style: true }

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
