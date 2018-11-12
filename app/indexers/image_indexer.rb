# Generated via
#  `rails generate hyrax:work Image`
class ImageIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  def rdf_service
    Class.new(Hyrax::DeepIndexingService) do
      def add_assertions(*args)
        object.fetch_missing_labels
        # Skip all intermediate ancestors and call the base IndexingService's add_assertions method
        ActiveFedora::RDF::IndexingService.instance_method(:add_assertions).bind(self).call(*args)
      end
    end
  end

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

  def index_technical_metadata(solr_doc, file_set)
    [:width, :height, :bits_per_sample, :compression, :photometric_interpretation,
     :make, :model, :x_resolution, :y_resolution, :icc_profile_description].each do |attribute|
      (solr_doc["#{attribute}_sim"] ||= []) << file_set.characterization_proxy.send(attribute).first
    end
  end
  # rubocop:enable Metrics/AbcSize
end
