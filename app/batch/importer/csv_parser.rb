module Importer
  # rubocop:disable Metrics/ClassLength
  class CSVParser
    include Enumerable
    attr_reader :email

    def initialize(content)
      @content = content
      # Read email from first row
      read_email
    end

    # @yieldparam attributes [Hash] the attributes from one row of the file
    def each(&_block)
      headers = nil
      CSV.parse(@content, encoding: 'iso-8859-1:utf-8') do |row|
        if headers
          # we already have headers, so this is not the first row.
          yield attributes(headers, row)
        else
          # Read headers
          headers = validate_headers(row)
        end
      end
    end

    private

      def email_row?(row)
        row.length == 1 && row.first.match?(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      end

      def read_email
        row = CSV.parse(@content).first
        @email = row.first if email_row?(row)
      end

      # Match headers like "lc_subject_type"
      def type_header_pattern
        /\A.*_type\Z/
      end

      def validate_headers(row)
        row.compact!
        difference = (row - valid_headers)
        return nil if email_row?(difference)

        # Allow headers with the pattern *_type to specify the
        # record type for a local authority.
        # e.g. For an author, author_type might be 'Person'.
        difference.delete_if { |h| h.match(type_header_pattern) }

        raise "Invalid headers: #{difference.join(', ')}" if difference.present?

        validate_header_pairs(row)
        row
      end

      # If you have a header like lc_subject_type, the next
      # header must be the corresponding field (e.g. lc_subject)
      def validate_header_pairs(row)
        errors = []
        row.each_with_index do |header, i|
          next if header == 'resource_type'
          next unless header.match?(type_header_pattern)
          next_header = row[i + 1]
          field_name = header.gsub('_type', '')
          if next_header != field_name
            errors << "Invalid headers: '#{header}' column must be immediately followed by '#{field_name}' column."
          end
        end
        raise errors.join(', ') if errors.present?
      end
      # rubocop:enable Metrics/MethodLength

      def valid_headers
        Image.attribute_names + %w[id type file] + collection_headers
      end

      def collection_headers
        %w[collection_id collection_title collection_accession_number]
      end

      def attributes(headers, row)
        {}.tap do |processed|
          headers.each_with_index do |header, index|
            extract_field(header, row[index], processed)
          end
        end
      end

      # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
      def extract_field(header, val, processed)
        return unless val
        case header
        when 'type', 'id', 'accession_number', 'ark', 'call_number', 'preservation_level'
          # type and id are singular
          processed[header.to_sym] = val
        when /^(created|issued|date_copyrighted|date_valid)_(.*)$/
          key = "#{Regexp.last_match(1)}_attributes".to_sym
          # TODO: this only handles one date of each type
          processed[key] ||= [{}]
          update_date(processed[key].first, Regexp.last_match(2), val)
        when 'resource_type'
          extract_multi_value_field(header, val, processed)
        when type_header_pattern
          update_typed_field(header, val, processed)
        when /^contributor$/
          update_contributor(header, val, processed)
        when /^collection_(.*)$/
          processed[:collection] ||= {}
          update_collection(processed[:collection], Regexp.last_match(1), val)
        else
          last_entry = Array(processed[header.to_sym]).last
          if last_entry.is_a?(Hash) && !last_entry[:name]
            update_typed_field(header, val, processed)
          else
            extract_multi_value_field(header, val, processed)
          end
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize

      # Faking a typed field for now.
      # TODO: support other types of contributors
      def update_contributor(header, val, processed)
        key = header.to_sym
        processed[key] ||= []
        processed[key] << { name: [val.strip] }
      end

      def extract_multi_value_field(header, val, processed, key = nil)
        key ||= header.to_sym
        processed[key] ||= []
        val = val.strip
        # Workaround for https://jira.duraspace.org/browse/FCREPO-2038
        val.delete!("\r")
        processed[key] << (looks_like_uri?(val) ? RDF::URI(val) : val)
      end

      def looks_like_uri?(str)
        str =~ %r{^https?://}
      end

      # Fields that have an associated *_type column
      def update_typed_field(header, val, processed)
        if header.match?(type_header_pattern)
          stripped_header = header.gsub('_type', '')
          processed[stripped_header.to_sym] ||= []
          processed[stripped_header.to_sym] << { type: val }
        else
          fields = Array(processed[header.to_sym])
          fields.last[:name] = val
        end
      end

      def update_collection(collection, field, val)
        val = [val] unless %w[admin_policy_id id].include? field
        collection[field.to_sym] = val
      end

      def update_date(date, field, val)
        date[field.to_sym] ||= []
        date[field.to_sym] << val
      end
  end
  # rubocop:enable Metrics/ClassLength
end
