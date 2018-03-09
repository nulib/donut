module CachingFetcher
  def fetch(*args)
    Rails.cache.fetch(rdf_subject.to_s) do
      Rails.logger.info "Cache miss; loading from #{rdf_subject} (this is REALLY slow)"
      super(*args)
    end
  end
end
