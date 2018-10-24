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

    def fetch(*args)
      tries = 3
      begin
        super(*args).tap do
          LabelCache.where(uri: rdf_subject.to_s).first_or_create { |record| record.label = _preferred_label }
          @preferred_label = nil
        end
      rescue StandardError => e
        Rails.logger.warn("FETCH OF <#{rdf_subject}>FAILED: #{e.message}. Retries remaining: #{tries -= 1}")
        return self if tries.zero?
        sleep(5)
        retry
      end
    end

    private

      def _preferred_label
        return rdf_label.first if rdf_label.first.is_a? String
        english_label = rdf_label.select { |label| label.language == :en }.first.to_s
        english_label.present? ? english_label : rdf_label.first.to_s
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

      def fixup_geonames_uri(id)
        path = URI(id).tap { |uri| uri.host = 'sws.geonames.org' }.to_s
        path.end_with?('/') ? path : "#{path}/"
      end
  end
end
