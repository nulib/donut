module Donut
  class MigrationService
    attr_reader :client, :limit, :overwrite

    WORK_ADMINISTRATIVE_METADATA_FIELDS_SINGLE_VALUED = %w[project_cycle].freeze

    WORK_ADMINISTRATIVE_METADATA_FIELDS_MULTIVALUED = %w[
      production_manager
      project_cycle
      project_description
      project_manager
      project_name
      proposer
      task_number
    ].freeze

    WORK_ADMINISTRATIVE_METADATA_CODED_FIELDS = %w[
      preservation_level
      status
    ].freeze

    WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_SINGLE_VALUED = %w[
      ark
      nul_use_statement
      title
    ].freeze

    WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_MULTIVALUED = %w[
      abstract
      bibliographic_citation
      caption
      catalog_key
      description
      folder_name
      folder_number
      identifier
      keyword
      legacy_identifier
      notes
      physical_description_material
      physical_description_size
      provenance
      publisher
      related_material
      rights_holder
      scope_and_contents
      series
      source
      table_of_contents
    ].freeze

    WORK_DESCRIPTIVE_METADATA_CODED_FIELDS = %w[rights_statement].freeze

    WORK_DESCRIPTIVE_METADATA_CONTROLLED_FIELDS = %w[
      based_near
      creator
      genre
      language
      style_period
      subject_geographical
      subject_temporal
      subject_topical
      technique
    ].freeze

    def self.run(limit, overwrite)
      new(limit, overwrite).export
    end

    def initialize(limit, overwrite)
      @limit = limit
      @client = Aws::S3::Client.new
      @overwrite = overwrite
    end

    def export
      upload_manifests
      upload_csv
    end

    def records
      image_ids.map do |image_id|
        image = Image.find(image_id)
        manifest_key = "#{image.id}.json"
        next if !overwrite && existing_manifest?(manifest_key)

        {
          id: image.id,
          accession_number: image.accession_number,
          published: false,
          visibility: { id: image.visibility.upcase, scheme: 'visibility' },
          work_type: { id: 'IMAGE', scheme: 'work_type' },
          administrative_metadata: administrative_metadata(image),
          descriptive_metadata: descriptive_metadata(image),
          file_sets: file_set_data(image)
        }.compact
      end
    rescue Ldp::NotFound
      raise 'Error: No image was found for #{image.id}'
    end

    private

      def upload_manifests
        records.each do |record|
          client.put_object(
            acl: 'authenticated-read',
            body: remove_blank_values!(record).to_json,
            bucket: Settings.aws.buckets.export,
            key: "#{record.id}.json",
            content_type: 'application/json'
          )
        end
      end

      def upload_csv
        client.put_object(
          acl: 'authenticated-read',
          body: images_and_representative_ids_csv,
          bucket: Settings.aws.buckets.export,
          key: 'images_and_representative_ids.csv',
          content_type: 'text/csv'
        )
      end

      def image_ids
        ActiveFedora::SolrService
          .query('*:*', fq: ['has_model_ssim:Image'], fl: ['id'], rows: limit)
          .map(&:id)
      end

      def images_and_representative_ids_csv
        images_and_representative_ids_query.map(&:to_csv).join('\n')
      end

      def images_and_representative_ids_query
        ActiveFedora::SolrService.query(
          '*:*',
          fq: ['has_model_ssim:Image'],
          fl: %w[id hasRelatedMediaFragment_ssim],
          rows: 200_000
        ).map do |h|
          if h['hasRelatedMediaFragment_ssim'].present?
            [h['id'], h['hasRelatedMediaFragment_ssim'].first]
          end
        end.compact
      end

      def remove_blank_values!(hash)
        hash.each do |k, v|
          if v.blank? && v != false
            hash.delete(k)
          elsif v.is_a?(Hash)
            hash[k] = remove_blank_values!(v)
          end
        end
      end

      def existing_manifest?(manifest_key)
        bucket_keys.include?(manifest_key)
      end

      def bucket_keys
        @bucket_keys ||= list_bucket
      end

      def list_bucket
        client
          .list_objects(bucket: Settings.aws.buckets.export)
          .flat_map { |response| response.contents.map(&:key) }
      end

      def descriptive_metadata(image)
        {}.tap do |descriptive_metadata|
          descriptive_metadata['date_created'] =
            image.date_created.map { |d| { edtf: Date.edtf(d).edtf } }
          descriptive_metadata['contributor'] =
            convert_coded_term_mapping(contributor_mapping, image)
          descriptive_metadata['subject'] =
            convert_coded_term_mapping(subject_mapping, image)

          WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_SINGLE_VALUED
            .each do |field|
            descriptive_metadata[field_mapping.fetch(field)] =
              Array(image.attributes.fetch(field)).first
          end

          WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_MULTIVALUED
            .each do |field|
            descriptive_metadata[field_mapping.fetch(field)] =
              image.attributes.fetch(field)
          end

          WORK_DESCRIPTIVE_METADATA_CONTROLLED_FIELDS.each do |field|
            descriptive_metadata[field_mapping.fetch(field)] =
              image
              .attributes
              .fetch(field)
              .map(&:id)
              .map { |id| { term: { id: id.chomp('/') } } }
          end
        end
      end

      def administrative_metadata(image)
        {}.tap do |administrative_metadata|
          WORK_ADMINISTRATIVE_METADATA_FIELDS_MULTIVALUED.each do |field|
            administrative_metadata[field_mapping.fetch(field)] =
              image.attributes.fetch(field)
          end

          WORK_ADMINISTRATIVE_METADATA_FIELDS_SINGLE_VALUED.each do |field|
            administrative_metadata[field_mapping.fetch(field)] =
              Array(image.attributes.fetch(field)).first
          end

          administrative_metadata['library_unit'] =
            admin_set_mapping.fetch(image.admin_set_id, nil)
          administrative_metadata['status'] = {
            id: image.status.upcase,
            scheme: 'status'
          }
          administrative_metadata['preservation_level'] = {
            id: image.preservation_level,
            scheme: 'preservation_level'
          }
        end
      end

      def file_set_data(image)
        image
          .ordered_members
          .to_a
          .map
          .with_index(1) do |file_set, index|
            {}.tap do |file_set_data|
              file_set_data[:id] = file_set.id
              file_set_data[:accession_number] =
                if index < 10
                  "#{image.accession_number}_donut_0#{index}"
                else
                  "#{image.accession_number}_donut_#{index}"
                end
              file_set_data[:role] = 'am'
              file_set_data[:metadata] = {
                "location": fedora_binary_s3_uri_for(file_set),
                "original_filename": File.basename(file_set.import_url),
                # "characterization_data": file_set.exif_all_data.first
              }
            end
          end
      end

      def fedora_binary_s3_uri_for(file_set)
        premis_digest = file_set.original_file.file_hash.first.id.split(':').last
        "s3://#{Settings.aws.buckets.fedora}/#{premis_digest}"
      rescue Ldp::NotFound
        raise "Error: No original file for was found for #{file_set.id}"
      end

      def field_mapping
        {
          'abstract' => 'abstract',
          'ark' => 'ark',
          'based_near' => 'location',
          'bibliographic_citation' => 'citation',
          'caption' => 'caption',
          'catalog_key' => 'catalog_key',
          'contributor' => 'contributor',
          'creator' => 'creator',
          'description' => 'description',
          'folder_name' => 'folder_name',
          'folder_number' => 'folder_number',
          'genre' => 'genre',
          'identifier' => 'identifier',
          'keyword' => 'keywords',
          'language' => 'language',
          'legacy_identifier' => 'legacy_identifier',
          'notes' => 'notes',
          'nul_use_statement' => 'terms_of_use',
          'physical_description_material' => 'physical_description_material',
          'physical_description_size' => 'physical_description_size',
          'preservation_level' => 'preservation_level',
          'production_manager' => 'project_manager',
          'project_cycle' => 'project_cycle',
          'project_description' => 'project_desc',
          'project_manager' => 'project_manager',
          'project_name' => 'project_name',
          'proposer' => 'project_proposer',
          'provenance' => 'provenance',
          'publisher' => 'publisher',
          'related_material' => 'related_material',
          'rights_holder' => 'rights_holder',
          'scope_and_contents' => 'scope_and_contents',
          'series' => 'series',
          'source' => 'source',
          'status' => 'status',
          'style_period' => 'style_period',
          'subject_geographical' => 'subject_geographical',
          'subject_temporal' => 'subject_temporal',
          'subject_topical' => 'subject_topical',
          'table_of_contents' => 'table_of_contents',
          'task_number' => 'project_task_number',
          'technique' => 'technique',
          'title' => 'title'
        }
      end

      def admin_set_mapping
        {
          '4d090cfa-f802-4ac3-9fe4-b5adc0294e80' => {
            term: { id: 'TRANSPORTATION_LIBRARY' }
          },
          '810fb25f-bc4a-47f9-9de3-d57f6513699f' => {
            term: { id: 'UNIVERSITY_ARCHIVES' }
          },
          '8d2b3787-4cc2-4830-af07-320c32f0cb9d' => {
            term: { id: 'UNIVERSITY_MAIN_LIBRARY' }
          },
          '9aaa1ade-740f-400c-b35d-d35fb6b6dad0' => {
            term: { id: 'FACULTY_COLLECTIONS' }
          },
          'b3771d7c-5117-4b48-a237-a0a6f02bc048' => {
            term: { id: 'SPECIAL_COLLECTIONS' }
          },
          'ce79271f-aeeb-42a0-bb7b-d945223aadce' => {
            term: { id: 'GOVERNMENT_AND_GEOGRAPHIC_INFORMATION_COLLECTION' }
          },
          'd04a355d-a0d5-430e-a01f-1885142e6d93' => {
            term: { id: 'MUSIC_LIBRARY' }
          },
          'fb560cc3-ea2b-41b0-bc0f-5e495c4f3f7f' => {
            term: { id: 'HERSKOVITS_LIBRARY' }
          }
        }
      end

      def convert_coded_term_mapping(mapping, image)
        mapping.keys.flat_map do |field|
          image
            .attributes
            .fetch(field)
            .map(&:id)
            .map { |id| mapping.fetch(field).merge(term: { id: id }) }
        end
      end

      def contributor_mapping
        {
          'architect' => { role: { id: 'arc', scheme: 'marc_relator' } },
          'artist' => { role: { id: 'art', scheme: 'marc_relator' } },
          'author' => { role: { id: 'aut', scheme: 'marc_relator' } },
          'cartographer' => { role: { id: 'ctg', scheme: 'marc_relator' } },
          'collector' => { role: { id: 'col', scheme: 'marc_relator' } },
          'compiler' => { role: { id: 'com', scheme: 'marc_relator' } },
          'composer' => { role: { id: 'cmp', scheme: 'marc_relator' } },
          'contributor' => { role: { id: 'ctb', scheme: 'marc_relator' } },
          'designer' => { role: { id: 'dsr', scheme: 'marc_relator' } },
          'director' => { role: { id: 'drt', scheme: 'marc_relator' } },
          'distributor' => { role: { id: 'dst', scheme: 'marc_relator' } },
          'donor' => { role: { id: 'dnr', scheme: 'marc_relator' } },
          'draftsman' => { role: { id: 'drm', scheme: 'marc_relator' } },
          'editor' => { role: { id: 'edt', scheme: 'marc_relator' } },
          'engraver' => { role: { id: 'egr', scheme: 'marc_relator' } },
          'illustrator' => { role: { id: 'ill', scheme: 'marc_relator' } },
          'librettist' => { role: { id: 'lbt', scheme: 'marc_relator' } },
          'musician' => { role: { id: 'mus', scheme: 'marc_relator' } },
          'performer' => { role: { id: 'prf', scheme: 'marc_relator' } },
          'photographer' => { role: { id: 'pht', scheme: 'marc_relator' } },
          'presenter' => { role: { id: 'pre', scheme: 'marc_relator' } },
          'printer' => { role: { id: 'prt', scheme: 'marc_relator' } },
          'printmaker' => { role: { id: 'prm', scheme: 'marc_relator' } },
          'producer' => { role: { id: 'pro', scheme: 'marc_relator' } },
          'screenwriter' => { role: { id: 'aus', scheme: 'marc_relator' } },
          'sculptor' => { role: { id: 'scl', scheme: 'marc_relator' } },
          'sponsor' => { role: { id: 'spn', scheme: 'marc_relator' } },
          'transcriber' => { role: { id: 'trc', scheme: 'marc_relator' } }
        }
      end

      def subject_mapping
        {
          # 'subject' => { role: { id: 'DONUT', scheme: 'subject_role' } },
          'subject_geographical' => {
            role: { id: 'GEOGRAPHICAL', scheme: 'subject_role' }
          },
          'subject_topical' => {
            role: { id: 'TOPICAL', scheme: 'subject_role' }
          }
        }
      end
  end
end