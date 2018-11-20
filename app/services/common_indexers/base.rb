
module CommonIndexers
  class Base
    attr_reader :source

    EXPLICIT_TYPES = { 'nul_contributor' => 'Contributor' }.freeze

    def initialize(source)
      @source = source
    end

    def multi_merge(*hashes)
      {}.tap do |result|
        hashes.each { |hash| result.merge!(hash) }
      end
    end

    def all_dates(edtf_date)
      Array(edtf_date).map do |date|
        Array(Date.edtf(date))
      end.flatten.sort.uniq
    end

    def date(edtf_date)
      all_dates(edtf_date).map(&:iso8601)
    end

    def extract_years(edtf_date)
      all_dates(edtf_date).map(&:year).uniq
    end

    def display_date(edtf_date)
      edtf_date.map { |date| Date.edtf(date).humanize }
    end

    def sortable_date(date_field)
      return if date_field.nil?
      if date_field.respond_to?(:iso8601)
        date_field.iso8601
      else
        DateTime.parse(date_field).iso8601
      end
    end

    def model
      {
        model: {
          application: Rails.application.class.parent.name,
          name: source.class.name
        }
      }
    end

    def values(*fields)
      {}.tap do |result|
        fields.each do |field|
          value = source.send(field)
          result[field] = value if value.present?
        end
      end
    end

    def labels(*fields)
      {}.tap do |result|
        fields.each do |field|
          value = source.send(field)
          result[field] = value.map { |v| { uri: v.id, label: fetch_label(v) } } if value.present?
        end
      end
    end

    def facets(*fields)
      {}.tap do |result|
        fields.each do |field|
          value = source.send(field)
          key = (field.to_s + '_facet').to_sym
          result[key] = value.map { |v| fetch_label(v) } if value.present?
        end
      end
    end

    def typed_values(*fields)
      [].tap do |result|
        fields.each do |field|
          (name, type) = field.is_a?(Array) ? field.map(&:to_s) : [field.to_s, field.to_s]

          next if source[name].blank?
          Array(source[name]).each do |value|
            (uri, label) = fetch_uri_and_label(value)
            result << { role: type, uri: uri, label: label }
          end
        end
      end
    end

    def contributors(*fields)
      [].tap do |result|
        fields.each do |field|
          (name, type) = field.is_a?(Array) ? field.map(&:to_s) : [field.to_s, field.to_s]

          next if source[name].blank?
          Array(source[name]).each do |value|
            (uri, label) = fetch_uri_and_label(value)
            result << { role: type, uri: uri, label: "#{label} (#{label_qualifier(type)})" }
          end
        end
      end
    end

    def method_missing(sym, *args)
      respond_to_missing?(sym) ? source.send(sym, *args) : super
    end

    def respond_to_missing?(sym)
      source.respond_to?(sym)
    end

    private

      def label_qualifier(type)
        EXPLICIT_TYPES[type] || type.capitalize
      end

      def fetch_label(value)
        value.preferred_label
      end

      def fetch_uri_and_label(value)
        value.is_a?(ControlledVocabularies::Base) ? [value.id, value.preferred_label] : [nil, value]
      end
  end
end
