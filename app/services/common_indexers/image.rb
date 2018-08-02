module CommonIndexers
  class Image < Base
    def assemble_index
      assemble(
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

    def fields
      {
        admin_set: { id: admin_set&.id, title: admin_set&.title },
        collection: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor: contributor,
        date: date_created,
        expanded_date: date(date_created),
        permalink: ark,
        subject: typed_values(:subject, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        title: { primary: title, alternate: alternate_title },
        extra_fields: extra_fields
      }
    end
  end
end
