::CommonIndexer.config do |config|
  config.endpoint = Settings.common_indexer.endpoint
  config.allowed_keys = Settings.common_indexer.allowed_keys
end
