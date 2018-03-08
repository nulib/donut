module CachingFetcher
  def fetch(*args)
    Rails.cache.fetch(rdf_subject.to_s) {
      Rails.logger.info "Cache miss; loading from #{rdf_subject.to_s} (this is REALLY slow)"
      super(*args)
    }
  end
end
