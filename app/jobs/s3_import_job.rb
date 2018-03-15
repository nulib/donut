require 'importer'

class S3ImportJob < ApplicationJob
  attr_reader :bucket, :csv_file_key

  def perform(s3_url)
    uri = Addressable::URI.parse(s3_url)
    @bucket = uri.host
    @csv_file_key = Pathname.new(uri.path).relative_path_from(Pathname.new('/')).to_s

    validate_bucket!
    validate_csv_file!

    size = Importer::CSVImporter.new(csv_file, csv_resource, job_id).import_all
    Rails.logger.info("#{size} records imported from #{s3_url}")
  end

  private

    def s3_client
      @s3_client ||= Aws::S3::Client.new
    end

    def s3_resource
      @s3_resource ||= Aws::S3::Resource.new
    end

    def csv_file
      s3_client.get_object(bucket: bucket, key: csv_file_key).body.read
    end

    def csv_resource
      Aws::S3::Object.new(client: s3_client, bucket_name: bucket, key: csv_file_key)
    end

    def validate_bucket!
      obj = s3_resource.bucket(bucket)
      raise ArgumentError, "Bucket `#{obj}' not found" unless obj.exists?
    end

    def validate_csv_file!
      bucket_obj = s3_resource.bucket(bucket)
      obj = bucket_obj.object(csv_file_key)
      raise ArgumentError, "Object `#{csv_file_key}' not found in bucket `#{bucket}'" unless obj.exists?
    end
end
