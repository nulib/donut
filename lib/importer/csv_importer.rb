module Importer
  # Import a csv file with one work per row. The first row of the csv should be a
  # header row. The model for each row can either be specified in a column called
  # 'type' or globally by passing the model attribute
  class CSVImporter
    # @param [String] CSV contents
    # @param [Aws::S3::Bucket] S3 Bucket, passed to factory constructor
    def initialize(csv, s3_resource)
      @csv = csv
      @s3_resource = s3_resource
    end

    # @return [Integer] count of objects created
    def import_all
      count = 0
      parser.each do |attributes|
        create_fedora_objects(attributes)
        count += 1
      end
      count
    end

    private

      def parser
        CSVParser.new(@csv)
      end

      # @return [Class] the model class to be used
      def factory_class(model)
        return model if model.is_a?(Class)
        if model.empty?
          $stderr.puts 'ERROR: No model was specified'
          exit(1) # rubocop:disable Rails/Exit
        end
        return Factory.for(model.to_s) if model.respond_to?(:to_s)
        raise "Unrecognized model type: #{model.class}"
      end

      # Build a factory to create the objects in fedora.
      # @param [Hash<Symbol => String>] attributes
      # @option attributes [String] :type overrides model for a single object
      # @note remaining attributes are passed to factory constructor
      def create_fedora_objects(attributes)
        factory_class(attributes.delete(:type)).new(attributes, @s3_resource).run
      end
  end
end
