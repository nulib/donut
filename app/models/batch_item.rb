class BatchItem < ApplicationRecord
  DUPLICATE_STATUSES = ['complete', 'initialized'].freeze

  belongs_to :batch
  serialize :attribute_hash, Hash
  serialize :error, Hash

  after_initialize do |obj|
    obj.status ||= 'initialized'
  end

  def run
    return unless runnable_item?
    new_object = factory.run(user: batch.deposit_user)
    self.created_item = new_object&.id
    complete!
  rescue StandardError => e
    error!(e.class.name => [e.message])
    Rails.logger.info %(Error for Batch Item: #{id}, from Batch #{batch.id}: #{e.message} \n#{e.backtrace.join("\n")})
  end

  def complete!
    status!('complete')
  end

  def error!(error_hash)
    status!('error', error_hash)
  end

  def status!(new_status, new_error = nil)
    tap do |s|
      s.status = new_status
      s.error = new_error
      s.save
    end
  end

  private

    def runnable_item?
      unique? && attributes_valid?
    end

    def attributes_valid?
      return true if accession_number.present? && factory.valid?
      all_errors = factory.errors.messages.dup
      all_errors[:accession_number] = ['Batch entry must have an accession number.'] if accession_number.nil?
      error!(all_errors)
      false
    end

    def unique?
      return true unless dupes_in_batch? || dupes_in_solr?
      status!('skipped', accession_number: "An object with accession number '#{accession_number}' has already been imported.")
      false
    end

    def dupes_in_batch?
      BatchItem.find_by('accession_number = ? AND status IN (?) AND ID != ?', accession_number, DUPLICATE_STATUSES, id).present?
    end

    def dupes_in_solr?
      Donut::DuplicateAccessionVerificationService.duplicate?(accession_number)
    end

    # Build a factory to create the objects in fedora.
    # @note remaining attributes are passed to factory constructor
    def factory
      return @factory unless @factory.nil?
      working_attrs = attribute_hash.dup
      s3_url = Addressable::URI.parse(working_attrs.delete(:batch_location))
      s3_resource = Aws::S3::Object.new(bucket_name: s3_url.host, key: s3_url.path.sub(%r{^/}, ''))
      @factory = factory_class(working_attrs.delete(:type)).new(working_attrs, s3_resource)
    end

    # @return [Class] the model class to be used
    def factory_class(model)
      return model if model.is_a?(Class)
      raise ArgumentError, 'ERROR: No model was specified' if model.blank?
      begin
        return ::Importer::Factory.for(model.to_s) if model.respond_to?(:to_s)
      rescue NameError
        Rails.logger.warn "Unrecognized model type: #{model}"
        raise "Unrecognized model type: #{model}"
      end
    end
end
