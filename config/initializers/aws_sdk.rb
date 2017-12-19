require 'aws-sdk'

if Settings.aws.endpoint.present?
  Aws.config.update(
    endpoint: Settings.aws.endpoint,
    region: Settings.aws.region,
    credentials: Aws::Credentials.new(Settings.aws.aws_access_key_id, Settings.aws.aws_secret_key_id),
    force_path_style: true
  )
end
