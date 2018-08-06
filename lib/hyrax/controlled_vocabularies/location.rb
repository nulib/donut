module Hyrax
  module ControlledVocabularies
    class Location < ActiveTriples::Resource
      configure rdf_label: ::RDF::Vocab::GEONAMES.name
      include CachingFetcher
      require 'rdf/rdfxml'

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

        def latitude_and_longitude
          query = RDF::Query.new(location: {
                                   RDF::URI('http://www.w3.org/2003/01/geo/wgs84_pos#lat') => :lat,
                                   RDF::URI('http://www.w3.org/2003/01/geo/wgs84_pos#long') => :long
                                 })
          results = query.execute(graph)
          lat = results.first[:lat].to_s
          long = results.first[:long].to_s
          { lat: lat, lon: long }
        end
    end
  end
end
