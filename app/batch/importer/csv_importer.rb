module Importer
  # Import a csv file with one work per row. The first row of the csv should be a
  # header row. The model for each row can either be specified in a column called
  # 'type' or globally by passing the model attribute
  class CSVImporter
    # @param [String] CSV contents
    # @param [Aws::S3::Bucket] S3 Bucket, passed to factory constructor
    def initialize(csv, s3_resource, job_id)
      @csv = csv
      @s3_resource = s3_resource
      @job_id = job_id
    end

    # @return [Integer] count of objects created
    def import_all
      return if parser.nil?
      @batch = Batch.create(
        submitter: parser.email,
        job_id: @job_id,
        original_filename: @s3_resource.key
      )
      begin
        parser.each_with_index do |attributes, index|
          create_item_row(attributes.merge(row_number: index + 1, batch_location: s3_url))
        end
        BatchJob.perform_later(@batch)
      rescue CSVParser::ParserError => error
        create_error_row(error)
      end
    end

    private

      def parser
        @parser ||= CSVParser.new(@csv)
      rescue CSV::MalformedCSVError => error
        @batch = Batch.create(
          submitter: 'unknown',
          job_id: @job_id,
          original_filename: @s3_resource.key
        )
        create_error_row(error)
        return nil
      end

      def s3_url
        "s3://#{@s3_resource.bucket.name}/#{@s3_resource.key}"
      end

      def create_item_row(attributes)
        @batch.batch_items << BatchItem.create(
          row_number: attributes.delete(:row_number),
          accession_number: attributes[:accession_number],
          attribute_hash: attributes
        )
      end

      def create_error_row(error)
        @batch.batch_items.create(
          row_number: 0,
          accession_number: @batch.job_id,
          attribute_hash: {},
          status: 'error',
          error: { batch: error.message }
        )
      end
  end
end
