Hyrax::CollectionPresenter.class_eval do
  def banner_file
    # Find Banner filename
    ci = CollectionBrandingInfo.where(collection_id: id, role: 'banner').first
    Aws::S3::Object.new(Settings.aws.buckets.branding, ci.local_path).presigned_url(:get) unless ci.nil?
  end

  def logo_record
    logo_info = []
    # Find Logo filename, alttext, linktext
    cis = CollectionBrandingInfo.where(collection_id: id, role: 'logo')
    return if cis.empty?
    cis.each do |info|
      filename = File.basename(info.local_path)
      url = Aws::S3::Object.new(Settings.aws.buckets.branding, info.local_path).presigned_url(:get)
      alttext = info.alt_text
      linkurl = info.target_url
      logo_info << { file: filename, file_location: url, alttext: alttext, linkurl: linkurl }
    end
    logo_info
  end
end
