module CachingFetcher
  def fetch(*args)
    cache_key = "fetch:#{rdf_subject}"
    cached_graph = Rails.cache.read(cache_key)
    if cached_graph.nil?
      Rails.logger.info "SUPERFETCH #{rdf_subject}!"
      super(*args)
      Rails.cache.write(cache_key, compress(graph.dump(:ntriples)))
    else
      load_graph_from_cache(cached_graph)
    end
    self
  end

  private

    def load_graph_from_cache(cached_graph)
      RDF::Reader.for(:ntriples).new(decompress(cached_graph)) do |reader|
        reader.each_statement do |statement|
          graph << statement
        end
      end
    end

    def compress(data)
      StringIO.new.tap do |output|
        zip = Zip::Deflater.new(output)
        zip << data
        zip.finish
      end.string
    end

    def decompress(data)
      Zip::Inflater.new(StringIO.new(data)).sysread
    rescue
      data
    end
end
