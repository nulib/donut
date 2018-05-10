module Donut
  module CollectionIndexer
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
        file_id = file_set.original_file.id.split(%r{/files/}).last
        IiifDerivativeService.resolve(file_id).to_s
      end
  end
end
