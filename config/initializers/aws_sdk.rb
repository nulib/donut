require 'aws-sdk'

if Settings.aws.endpoint.present?
  Aws.config.update(
    endpoint: Settings.aws.endpoint,
    force_path_style: true
  )
end
