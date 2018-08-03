module CommonIndexers
  class Image < Base
    def generate
      multi_merge(
        model,
        fields,
        values(:abstract, :caption, :description, :keyword, :provenance, :publisher, :rights_holder, :source, :visibility),
        labels(:language)
      )
    end

    def contributor
      typed_values(
        :architect, :artist, :author, :cartographer, :compiler, :composer,
        :contributor, :creator, :designer, :director, :draftsman, :editor, :engraver,
        :illustrator, :librettist, :nul_creator, :performer, :photographer, :presenter,
        :printer, :printmaker, :producer, :production_manager, :screenwriter, :sculptor,
        :sponsor
      )
    end

    def extra_fields
      {
        physical_description: { material: physical_description_material, size: physical_description_size }
      }.merge(labels(:genre, :style_period, :technique))
    end

    def fields # rubocop:disable Metrics/AbcSize
      {
        admin_set: { id: admin_set&.id, title: admin_set&.title },
        collection: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor: contributor,
        date: date_created,
        expanded_date: date(date_created),
        year: extract_years(date_created),
        permalink: ark,
        subject: typed_values(:subject, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        title: { primary: title, alternate: alternate_title },
        thumbnail_url: thumbnail,
        iiif_manifest: iiif_manifest,
        extra_fields: extra_fields
      }
    end

    private

    def thumbnail
      return nil if representative_file.nil?
      IiifDerivativeService.resolve(representative_file).join('square/300,/0/default.jpg')
    end

    def iiif_manifest
      return nil if representative_file.nil?
      IiifDerivativeService.resolve(representative_file).join('info.json')
    end

    def representative_file
      return nil if representative_id.nil?
      FileSet.find(representative_id).files.first.id
    end
  end
end
