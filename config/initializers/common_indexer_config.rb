::CommonIndexer.config do |config|
  config.endpoint = Settings.common_indexer.endpoint
end
::CommonIndexer.configure_index!
