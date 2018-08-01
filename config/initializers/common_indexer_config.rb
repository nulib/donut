::CommonIndexer.config do |config|
  config.endpoint = Settings.common_indexer.endpoint
  config.allowed_keys = [
    :abstract, :admin_set, :caption, :collection, :contributor, :date,
    :description, :genre, :keyword, :language, :model, :permalink,
    :physical_description, :provenance, :publisher, :rights_holder, :source,
    :style_period, :subject, :technique, :title, :visibility
  ]
end
