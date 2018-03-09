module ControlledVocabularies
  class StylePeriod < Base
    # Return a tuple of url & label
    def solrize
      return [rdf_subject.to_s] unless label_present
      [rdf_subject.to_s, { label: "#{preferred_label}$#{rdf_subject}" }]
    end

    def label_present
      rdf_label.first.to_s.present? && rdf_label.first.to_s != rdf_subject.to_s
    end

    def preferred_label
      english_label = rdf_label.select { |label| label.language == :en }.first.to_s
      english_label.present? ? english_label : rdf_label.first.to_s
    end
  end
end
