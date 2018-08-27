module CommonIndexers
  class Base
    attr_reader :source

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

    def location(field)
      {}.tap do |result|
        value = source.send(field)
        result[:location] = value.first.fetch.geo_point unless value.empty?
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
          result[field] = value unless value.empty?
        end
      end
    end

    def labels(*fields)
      {}.tap do |result|
        fields.each do |field|
          value = source.send(field)
          result[field] = value.map { |v| { uri: v.id, label: v.fetch.preferred_label } } unless value.empty?
        end
      end
    end

    def typed_values(*fields)
      [].tap do |result|
        fields.each do |field|
          (name, type) = field.is_a?(Array) ? field.map(&:to_s) : [field.to_s, field.to_s]

          next if source[name].empty?
          Array(source[name]).each do |value|
            (uri, label) = value.is_a?(ControlledVocabularies::Base) ? [value.id, value.fetch.preferred_label] : [nil, value]
            result << { type: type, uri: uri, label: label }
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
  end
end
