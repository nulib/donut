# Generated via
#  `rails generate hyrax:work Image`
class ImageIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  # Custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc['date_created_display_tesim'] = object.date_created.map { |d| Date.edtf(d).humanize }
      object.member_ids.each do |file_set_id|
        file_set = ::FileSet.find(file_set_id)
        next if file_set.original_file.nil?
        (solr_doc['file_set_iiif_urls_ssim'] ||= []) << IiifDerivativeService.resolve(file_set.original_file.id).to_s
      end
    end
  end
end
