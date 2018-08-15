module CommonIndexers
  class Image < Base
    def generate
      multi_merge(
        model,
        fields,
        values(:abstract, :caption, :description, :keyword, :provenance, :publisher, :rights_holder, :source, :visibility),
        labels(:language),
        location(:based_near)
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
        id: id,
        admin_set: { id: admin_set&.id, title: admin_set&.title },
        collection: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor: contributor,
        date: date_created,
        expanded_date: date(date_created),
        year: extract_years(date_created),
        permalink: ark,
        subject: typed_values(:subject, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        title: { primary: title, alternate: alternate_title },
        thumbnail_url: representative_file('square/300,/0/default.jpg'),
        iiif_manifest: representative_file('manifest.json'),
        fileset_iiif_urls: fileset_iiif_urls,
        representative_file_url: representative_file(''),
        extra_fields: extra_fields,
        resource_type: resource_type
      }
    end

    private

      def representative_file(suffix)
        return nil if representative_id.nil?
        fs = FileSet.find(representative_id)
        return nil if fs.files.empty?
        IiifDerivativeService.resolve(fs.files.first.id).join(suffix)
      end

      def fileset_iiif_urls
        [].tap do |result|
          file_set_ids.each do |file_set_id|
            file_set = ::FileSet.find(file_set_id)
            next if file_set.original_file.nil?
            result << IiifDerivativeService.resolve(file_set.original_file.id).to_s
          end
        end
      end
  end
end
