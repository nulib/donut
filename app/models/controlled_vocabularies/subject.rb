module ControlledVocabularies
  class Subject < ActiveTriples::Resource
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
      rdf_label.first.to_s.present? && rdf_label.first.to_s != rdf_subject.to_s
    end

    def preferred_label
      return rdf_label.first if rdf_label.first.is_a? String
      english_label = rdf_label.select { |label| label.language == :en }.first.to_s
      english_label.present? ? english_label : rdf_label.first.to_s
    end

    private

      def correct_uri_for(id)
        return if id.nil?
        value = case id.to_s
                when /^info:lc(.+)$/ then "http://id.loc.gov#{Regexp.last_match(1)}"
                when /^fst(.+)$/ then "http://id.worldcat.org/fast/#{Regexp.last_match(1)}"
                else id
                end
        ::RDF::URI(value)
      end
  end
end
