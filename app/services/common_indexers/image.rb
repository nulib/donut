module CommonIndexers
  class Image < Base
    def generate
      multi_merge(
        model,
        fields,
        values(:abstract, :caption, :description, :keyword, :provenance, :publisher, :rights_holder, :source, :visibility),
        labels(:language, :genre, :style_period, :technique),
        location(:based_near)
      )
    end

    def contributor
      contributors(
        :architect, :artist, :author, :cartographer, :compiler, :composer,
        :contributor, :designer, :director, :draftsman, :editor, :engraver,
        :illustrator, :librettist, :nul_contributor, :performer, :photographer, :presenter,
        :printer, :printmaker, :producer, :production_manager, :screenwriter, :sculptor,
        :sponsor
      )
    end

    def fields
      {
        id: id,
        admin_set_idd: { id: admin_set&.id, title: admin_set&.title },
        collection_idd: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor_ldr: contributor,
        creator_ldr: typed_values(:creator, :nul_creator),
        date: display_date(date_created),
        expanded_date_dt: date(date_created),
        year_i: extract_years(date_created),
        permalink: ark,
        subject_ldr: typed_values(:subject, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        title: { primary: title, alternate: alternate_title },
        thumbnail_url: representative_file('square/300,/0/default.jpg'),
        iiif_manifest: representative_file('manifest.json'),
        representative_file_url: representative_file(''),
        resource_type: resource_type,
        related_url: related_url,
        rights_statement: rights_statement,
        identifier: identifier,
        license: license,
        nul_use_statement: nul_use_statement,
        accession_number: accession_number,
        call_number: call_number,
        catalog_key: catalog_key,
        bibliographic_citation: bibliographic_citation,
        box: { name: box_name, number: box_number },
        folder: { name: folder_name, number: folder_number },
        physical_description: { material: physical_description_material, size: physical_description_size }
      }
    end

    private

      def representative_file(suffix)
        return nil if representative_id.nil?
        fs = FileSet.find(representative_id)
        return nil if fs.files.empty?
        IiifDerivativeService.resolve(fs.files.first.id).join(suffix)
      end
  end
end
