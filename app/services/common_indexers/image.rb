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
        collection: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor: contributor,
        creator: typed_values(:creator, :nul_creator),
        date: display_date(date_created),
        expanded_date: date(date_created),
        folder: { name: folder_name, number: folder_number },
        full_text: full_text_values,
        id: id,
        identifier: identifier,
        iiif_manifest: IiifManifestService.manifest_url(id),
        legacy_identifier: legacy_identifier,
        license: licenses,
        modified_date: sortable_date(date_modified),
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

      def representative_file(representative_id)
        return nil if representative_id.nil?
        object = ActiveFedora::Base.find(representative_id)
        if object.is_a?(::Image)
          representative_file(object.representative_id)
        else
          return nil if object.files.empty?
          IiifDerivativeService.resolve(object.original_file.id)
        end
      end

      def thumbnail(thumbnail_id)
        return nil if thumbnail_id.nil?
        object = ActiveFedora::Base.find(thumbnail_id)
        if object.is_a?(::Image)
          thumbnail(object.thumbnail_id)
        else
          return nil if object.files.empty?
          IiifDerivativeService.resolve(object.original_file.id)
        end
      end
  end
end
