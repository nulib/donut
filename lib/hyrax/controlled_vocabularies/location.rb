module Hyrax
  module ControlledVocabularies
    class Location < ActiveTriples::Resource
      configure rdf_label: ::RDF::Vocab::GEONAMES.name
      include CachingFetcher
      require 'rdf/rdfxml'

      def initialize(*args, &block)
        args[0] = correct_uri_for(args.first) unless args.first.is_a?(Hash)
        super(*args, &block)
      end

      def geo_point
        cache_key = "fetch:#{rdf_subject}"
        cached_graph = Rails.cache.read(cache_key)
        load_graph_from_cache(cached_graph)
        latitude_and_longitude
      end

      # Return a tuple of url & label
      def solrize
        return [rdf_subject.to_s] if rdf_label.first.to_s.blank? || rdf_label.first.to_s == rdf_subject.to_s
        [rdf_subject.to_s, { label: "#{rdf_label.first}$#{rdf_subject}" }]
      end

      private

        def correct_uri_for(id)
          return if id.nil?
          value = case id.to_s
                  when /^info:lc(.+)$/ then "http://id.loc.gov#{Regexp.last_match(1)}"
                  when /^fst(.+)$/ then "http://id.worldcat.org/fast/#{Regexp.last_match(1).sub!(/0+([1-9]+)/, '\1')}"
                  when /geonames.org/ then URI(id).tap { |uri| uri.host = 'sws.geonames.org' }.to_s
                  else id.to_s
                  end
          ::RDF::URI(value)
        end

        def latitude_and_longitude
          query = RDF::Query.new(location: {
                                   RDF::URI('http://www.w3.org/2003/01/geo/wgs84_pos#lat') => :lat,
                                   RDF::URI('http://www.w3.org/2003/01/geo/wgs84_pos#long') => :long
                                 })
          results = query.execute(graph)
          return {} if results.empty?
          lat = results.first[:lat].to_s
          long = results.first[:long].to_s
          { lat: lat, lon: long }
        end
    end
  end
end
