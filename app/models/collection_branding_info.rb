class CollectionBrandingInfo < ApplicationRecord
  before_destroy :cleanup_files

  def initialize(collection_id:,
                 filename:,
                 role:,
                 alt_txt: '',
                 target_url: '')

    super()
    self.collection_id = collection_id
    self.role = role
    self.alt_text = alt_txt
    self.target_url = target_url

    self.local_path = find_local_filename(collection_id, role, filename)
  end

  def save(file_location, copy_file = true)
    s3 = Aws::S3::Object.new(Settings.aws.buckets.branding, local_path)
    s3.upload_file(File.open(file_location)) if file_location != local_path || copy_file
    FileUtils.remove_file(file_location) if File.exist?(file_location) && copy_file
    super()
  end

  private

    def cleanup_files
      s3 = Aws::S3::Object.new(Settings.aws.buckets.branding, local_path)
      s3.delete
    end

    def find_local_filename(collection_id, role, filename)
      File.join(collection_id.to_s, role.to_s, filename)
    end
end
