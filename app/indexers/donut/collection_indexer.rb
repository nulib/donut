module Donut
  class CollectionIndexer < Hyrax::CollectionIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        if object.thumbnail_id.present?
          solr_doc['thumbnail_iiif_url_ss'] = thumbnail_iiif_url
        end
      end
    end

    private

      def thumbnail_iiif_url
        file_set = ::FileSet.find(object.thumbnail_id)
        IiifDerivativeService.resolve(file_set.original_file.id).to_s
      end
  end
end
