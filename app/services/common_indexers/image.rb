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
        :sponsor, :musician, :transcriber, :distributor, :donor, :collector
      )
    end

    def full_text_values
      [abstract, caption, description, keyword, publisher].collect(&:to_a).flatten.compact
    end

    def related_url_values
      related_url.collect do |entry|
        entry.is_a?(ActiveTriples::Resource) ? entry.id : entry
      end
    end

    def fields
      {
        id: id,
        admin_set: { id: admin_set&.id, title: admin_set&.title },
        collection: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor: contributor,
        creator: typed_values(:creator, :nul_creator),
        date: display_date(date_created),
        expanded_date: date(date_created),
        year: extract_years(date_created),
        permalink: ark,
        subject: typed_values(:subject, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        title: { primary: title, alternate: alternate_title },
        thumbnail_url: representative_file('square/300,/0/default.jpg'),
        iiif_manifest: IiifManifestService.manifest_url(id),
        representative_file_url: representative_file(''),
        resource_type: resource_type,
        related_url: related_url_values,
        rights_statement: rights_statement_object,
        identifier: identifier,
        legacy_identifier: legacy_identifier,
        license: licenses,
        nul_use_statement: nul_use_statement,
        accession_number: accession_number,
        call_number: call_number,
        catalog_key: catalog_key,
        bibliographic_citation: bibliographic_citation,
        box: { name: box_name, number: box_number },
        folder: { name: folder_name, number: folder_number },
        physical_description: { material: physical_description_material, size: physical_description_size },
        full_text: full_text_values
      }
    end

    private

      def licenses
        [].tap do |obj|
          license.each do |l|
            obj << { uri: l, label: Hyrax::LicenseService.new.label(l) }
          end
        end
      end

      def rights_statement_object
        return nil if rights_statement.blank?
        { uri: rights_statement.first, label: Hyrax::RightsStatementService.new.label(rights_statement.first) }
      end

      def representative_file(suffix)
        return nil if representative_id.nil?
        fs = FileSet.find(representative_id)
        return nil if fs.files.empty?
        IiifDerivativeService.resolve(fs.files.first.id).join(suffix)
      end
  end
end
