module CommonIndexers
  class Image < Base
    def generate
      multi_merge(
        model,
        fields,
        values(:abstract, :caption, :description, :keyword, :provenance, :publisher, :rights_holder, :source, :visibility),
        labels(:based_near, :language, :genre, :style_period, :technique)
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
        accession_number: accession_number,
        admin_set: { id: admin_set&.id, title: admin_set&.title },
        bibliographic_citation: bibliographic_citation,
        box: { name: box_name, number: box_number },
        call_number: call_number,
        catalog_key: catalog_key,
        collection: nul_collections,
        contributor: contributor,
        creator: typed_values(:creator, :nul_creator),
        create_date: sortable_date(create_date),
        date: display_date(date_created),
        expanded_date: date(date_created),
        folder: { name: folder_name, number: folder_number },
        id: id,
        identifier: identifier,
        iiif_manifest: IiifManifestService.manifest_url(id),
        legacy_identifier: legacy_identifier,
        license: licenses,
        member_ids: member_ids,
        modified_date: sortable_date(modified_date),
        notes: notes,
        nul_use_statement: nul_use_statement,
        permalink: ark,
        physical_description: { material: physical_description_material, size: physical_description_size },
        related_material: related_material,
        related_url: related_url_values,
        representative_file_url: representative_file(representative_id),
        resource_type: resource_type,
        rights_statement: rights_statement_object,
        scope_and_contents: scope_and_contents,
        series: series,
        subject: typed_values(:subject, :subject_temporal, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        table_of_contents: table_of_contents,
        thumbnail_url: thumbnail(thumbnail_id),
        title: { primary: title, alternate: alternate_title },
        uploaded_date: sortable_date(date_uploaded),
        year: extract_years(date_created)
      }
    end

    private

      def nul_collections
        member_of_collections.select { |c| c.collection_type_gid == Settings.nul_collection_type }.map { |c| { id: c.id, title: c.title.to_a } }
      end

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

      def target_file(id, path:)
        return nil if id.nil?
        object = ActiveFedora::Base.find(id)
        if object.is_a?(::Image)
          target_file(object.send(path), path: path)
        else
          IiifDerivativeService.resolve(object.id)
        end
      end

      def representative_file(id)
        target_file(id, path: :representative_id)
      end

      def thumbnail(id)
        target_file(id, path: :thumbnail_id)
      end
  end
end
