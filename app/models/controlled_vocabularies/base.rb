module ControlledVocabularies
  class Base < ActiveTriples::Resource
    require 'rdf/rdfxml'

    def initialize(*args, &block)
      args[0] = correct_uri_for(args.first) unless args.first.is_a?(Hash)
      super(*args, &block)
    end

    # Return a tuple of url & label
    def solrize
      return [rdf_subject.to_s] unless label_present
      [rdf_subject.to_s, { label: "#{preferred_label}$#{rdf_subject}" }]
    end

    def label_present
      preferred_label != rdf_subject.to_s
    end

    def preferred_label
      @preferred_label ||= LabelCache.find_by(uri: rdf_subject.to_s)&.label
      @preferred_label || _preferred_label
    end

    def default_labels
      @default_labels ||= super + [::RDF::Vocab::GEONAMES.name]
    end

    def fetch(*)
      tries = 3
      begin
        refresh_label_from(correct_fetch_url_for(rdf_subject))
      rescue StandardError => e
        Rails.logger.warn("FETCH OF <#{rdf_subject}>FAILED: #{e.message}. Retries remaining: #{tries -= 1}")
        return self if tries.zero?
        sleep(5)
        retry
      end
    end

    private

      def refresh_label_from(url)
        if graph.is_a?(RDF::Graph)
          graph.load(url)
        else
          RDF::Graph.load(url) do |fetched|
            fetched.query(subject: rdf_subject).each { |statement| graph.insert_statement(statement) }
          end
        end
        LabelCache.where(uri: rdf_subject.to_s).first_or_create { |record| record.label = _preferred_label }
        @preferred_label = nil
        self
      end

      def _preferred_label
        [
          rdf_label.find { |label| label.respond_to?(:language) && label.language == :'en-us' },
          rdf_label.find { |label| label.respond_to?(:language) && label.language == :en },
          rdf_label.find { |label| label.is_a?(String) },
          rdf_label.first,
          rdf_subject
        ].compact.first.to_s
      end

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

      def correct_fetch_url_for(id)
        case id.to_s
        when %r{id\.worldcat\.org/fast}
          "#{id}.rdf.xml"
        else
          id
        end
      end

      def fixup_geonames_uri(id)
        path = URI(id).tap do |uri|
          uri.scheme = 'https'
          uri.host = 'sws.geonames.org'
        end.to_s
        path.end_with?('/') ? path : "#{path}/"
      end
  end
end
