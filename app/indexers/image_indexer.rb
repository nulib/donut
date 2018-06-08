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
      object.file_set_ids.each do |file_set_id|
        file_set = ::FileSet.find(file_set_id)
        next if file_set.original_file.nil?
        (solr_doc['file_set_iiif_urls_ssim'] ||= []) << IiifDerivativeService.resolve(file_set.original_file.id).to_s
        index_technical_metadata(solr_doc, file_set)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def index_technical_metadata(solr_doc, file_set)
    (solr_doc['width_sim'] ||= []) << file_set.characterization_proxy.width.first
    (solr_doc['height_sim'] ||= []) << file_set.characterization_proxy.height.first
    (solr_doc['bits_per_sample_sim'] ||= []) << file_set.characterization_proxy.bits_per_sample.first
    (solr_doc['compression_sim'] ||= []) << file_set.characterization_proxy.compression.first
    (solr_doc['photometric_interpretation_sim'] ||= []) << file_set.characterization_proxy.photometric_interpretation.first
    (solr_doc['make_sim'] ||= []) << file_set.characterization_proxy.make.first
    (solr_doc['x_resolution_sim'] ||= []) << file_set.characterization_proxy.x_resolution.first
    (solr_doc['y_resolution_sim'] ||= []) << file_set.characterization_proxy.y_resolution.first
    (solr_doc['icc_profile_description_sim'] ||= []) << file_set.characterization_proxy.icc_profile_description.first
  end
  # rubocop:enable Metrics/AbcSize
end
