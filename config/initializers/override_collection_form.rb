# Ruby doesn't have the constants in this scope that the
# CollectionForm needs (Hyrax::SearchState), due to using
# a class_eval, so we have to require it here

# rubocop:disable Rails/DynamicFindBy
gem_dir = Gem::Specification.find_by_name('hyrax').gem_dir
# rubocop:enable Rails/DynamicFindBy
require "#{gem_dir}/lib/hyrax/search_state"

Hyrax::Forms::CollectionForm.class_eval do
  def banner_info
    @banner_info ||= begin
      # Find Banner filename
      banner = ::CollectionBrandingInfo.where(collection_id: id).where(role: 'banner').first
      filename = File.basename(banner.local_path) unless banner.nil?
      url = Aws::S3::Object.new(Settings.aws.buckets.branding, banner.local_path).presigned_url(:get) unless banner.nil?
      { file: filename, full_path: '', relative_path: url }
    end
  end

  def logo_info
    @logo_info ||= begin
      # Find Logo filename, alttext, linktext
      logos = ::CollectionBrandingInfo.where(collection_id: id).where(role: 'logo')
      logos.map do |info|
        filename = File.basename(info.local_path)
        url = Aws::S3::Object.new(Settings.aws.buckets.branding, info.local_path).presigned_url(:get)
        alttext = info.alt_text
        linkurl = info.target_url
        { file: filename, full_path: info.local_path, relative_path: url, alttext: alttext, linkurl: linkurl }
      end
    end
  end
end
