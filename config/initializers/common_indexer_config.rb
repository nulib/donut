require 'faraday_middleware/aws_sigv4'

::CommonIndexer.configure do |config|
  config.endpoint = Settings.common_indexer.endpoint
end

::CommonIndexer.configure_client do |f|
  f.request :aws_sigv4,
            service: 'es',
            region: Settings.aws_region,
            credentials_provider: Aws::CredentialProviderChain.new.resolve
end
