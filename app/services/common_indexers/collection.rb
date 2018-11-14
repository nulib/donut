module CommonIndexers
  class Collection < Base
    def generate
      multi_merge(
        model,
        fields,
        values(:description, :visibility, :keyword)
      )
    end

    def fields
      {
        id: id,
        title: { primary: title },
        thumbnail_iiif_url: thumbnail_iiif_url,
        collection_type_idd: type_of_collection,
        modified_date: sortable_date(modified_date),
        create_date: sortable_date(create_date)
      }
    end

    private

      def type_of_collection
        return {} unless collection_type
        { id: collection_type.id, title: collection_type.title }
      end

      def thumbnail_iiif_url
        return '' unless thumbnail_id
        file_set = ::FileSet.find(thumbnail_id)
        IiifDerivativeService.resolve(file_set.original_file.id).to_s
      end
  end
end
