module Hyrax
  module ControlledVocabularies
    class Location < ActiveTriples::Resource
      configure rdf_label: ::RDF::Vocab::GEONAMES.name
      require 'rdf/rdfxml'

      def initialize(*args, &block)
        args[0] = correct_uri_for(args.first) unless args.first.is_a?(Hash)
        super(*args, &block)
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
                  when /geonames.org/ then fixup_geonames_uri(id)
                  else id.to_s
                  end
          ::RDF::URI(value)
        end

        def fixup_geonames_uri(id)
          path = URI(id).tap { |uri| uri.host = 'sws.geonames.org' }.to_s
          path.end_with?('/') ? path : "#{path}/"
        end
    end
  end
end
