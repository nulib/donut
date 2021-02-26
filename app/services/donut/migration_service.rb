module Donut
  class MigrationService
    attr_reader :authority_map, :client, :limit

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

    WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_SINGLE_VALUED = %w[
      ark
      nul_use_statement
      title
    ].freeze

    WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_MULTIVALUED = %w[
      abstract
      alternate_title
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

    WORK_DESCRIPTIVE_METADATA_CONTROLLED_FIELDS = %w[
      based_near
      genre
      language
      style_period
      technique
    ].freeze

    def self.run(limit)
      new(limit).export
    end

    def initialize(limit)
      @limit = limit
      @client = Aws::S3::Client.new
      @authority_map = MeadowAuthorityMap.new(@client)
    end

    def export
      upload_manifests
    end

    def generate_record(image_id)
      image = Image.find(image_id)

      record = {
        id: image.id,
        accession_number: image.accession_number,
        published: false,
        visibility: {
          id: image.visibility.upcase,
          scheme: 'visibility'
        },
        work_type: {
          id: 'IMAGE',
          scheme: 'work_type'
        },
        collection_id:
          image.member_of_collections.select do |c|
            c.collection_type.id == 3
          end&.first&.id,
        administrative_metadata: administrative_metadata(image),
        descriptive_metadata: descriptive_metadata(image),
        file_sets: file_set_data(image),
        representative_file_set_id: image.representative_id
      }.compact

      remove_blank_values!(record)
    rescue Ldp::NotFound
      Rails.logger.warn('Migration error: No image was found for #{image_id}')
    end

    private

      def upload_manifests
        image_ids.map do |image_id|
          next if s3_exists?(image_id)

          record = generate_record(image_id)
          next if record.blank?

          client.put_object(
            body: record.to_json,
            bucket: Settings.aws.buckets.export,
            key: "#{record[:id]}.json",
            content_type: 'application/json'
          )

          Rails.logger.info(
            "#{record[:id]}.json uploaded to #{Settings.aws.buckets.export}."
          )
        end
      end

      def image_ids
        ActiveFedora::SolrService
          .query('*:*', fq: ['has_model_ssim:Image'], fl: ['id'], rows: limit)
          .map(&:id)
      end

      def s3_exists?(id)
        client.head_object(bucket: Settings.aws.buckets.export, key: "#{id}.json")
        true
      rescue StandardError
        false
      end

      def remove_blank_values!(hash = {})
        hash.each do |k, v|
          if v.blank? && v != false
            hash.delete(k)
          elsif v.is_a?(Hash)
            hash[k] = remove_blank_values!(v)
          end
        end
      end

      def descriptive_metadata(image)
        {}.tap do |descriptive_metadata|
          descriptive_metadata['date_created'] =
            image.date_created.map do |d|
              { edtf: Date.edtf(d).edtf.gsub(/[uxU]/, 'X').gsub(/[y]/, 'Y') }
            end
          descriptive_metadata['contributor'] =
            convert_coded_term_mapping(contributor_mapping, image)
          descriptive_metadata['subject'] =
            convert_coded_term_mapping(subject_mapping, image)
          descriptive_metadata['creator'] =
            %w[creator nul_creator].flat_map do |field|
              image.attributes.fetch(field).map { |value| value.is_a?(String) ? authority_map.to_id(value) : value.id }.map { |id| { term: { id: id } } }
            end.compact
          descriptive_metadata['related_url'] =
            image.related_url.map { |url| related_url_mapping(url) }
          descriptive_metadata['rights_statement'] = {
            id: image.rights_statement&.first,
            scheme: 'rights_statement'
          }

          WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_SINGLE_VALUED
            .each do |field|
            descriptive_metadata[field_mapping.fetch(field)] =
              Array(image.attributes.fetch(field)).first
          end

          WORK_DESCRIPTIVE_METADATA_UNCONTROLLED_FIELDS_MULTIVALUED
            .each do |field|
            descriptive_metadata[field_mapping.fetch(field)] =
              image.attributes.fetch(field).map(&:to_s)
          end

          WORK_DESCRIPTIVE_METADATA_CONTROLLED_FIELDS.each do |field|
            descriptive_metadata[field_mapping.fetch(field)] =
              image.attributes.fetch(field).map { |value| value.is_a?(String) ? authority_map.to_id(value) : value.id }.map { |id| { term: { id: id.chomp('/') } } }
          end
        end.compact
      end

      def administrative_metadata(image)
        {}.tap do |administrative_metadata|
          WORK_ADMINISTRATIVE_METADATA_FIELDS_MULTIVALUED.each do |field|
            administrative_metadata[field_mapping.fetch(field)] =
              image.attributes.fetch(field).map(&:to_s)
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
        end.compact
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
                "label": file_set.title&.first,
                "location": fedora_binary_s3_uri_for(file_set),
                "original_filename":
                  File.basename(URI.parse(file_set.import_url).path)
              }
            end.compact
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
          'alternate_title' => 'alternate_title',
          'ark' => 'ark',
          'based_near' => 'location',
          'bibliographic_citation' => 'citation',
          'caption' => 'caption',
          'catalog_key' => 'catalog_key',
          'contributor' => 'contributor',
          'description' => 'description',
          'folder_name' => 'folder_name',
          'folder_number' => 'folder_number',
          'genre' => 'genre',
          'identifier' => 'identifier',
          'keyword' => 'keywords',
          'language' => 'language',
          'legacy_identifier' => 'legacy_identifier',
          'notes' => 'notes',
          'nul_contributor' => 'contributor',
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
          'subject_temporal' => 'subject',
          'subject_topical' => 'subject',
          'table_of_contents' => 'table_of_contents',
          'task_number' => 'project_task_number',
          'technique' => 'technique',
          'title' => 'title'
        }
      end

      def admin_set_mapping
        {
          '4d090cfa-f802-4ac3-9fe4-b5adc0294e80' => {
            id: 'TRANSPORTATION_LIBRARY',
            scheme: 'library_unit'
          },
          '810fb25f-bc4a-47f9-9de3-d57f6513699f' => {
            id: 'UNIVERSITY_ARCHIVES',
            scheme: 'library_unit'
          },
          '8d2b3787-4cc2-4830-af07-320c32f0cb9d' => {
            id: 'UNIVERSITY_MAIN_LIBRARY',
            scheme: 'library_unit'
          },
          '9aaa1ade-740f-400c-b35d-d35fb6b6dad0' => {
            id: 'FACULTY_COLLECTIONS',
            scheme: 'library_unit'
          },
          'b3771d7c-5117-4b48-a237-a0a6f02bc048' => {
            id: 'SPECIAL_COLLECTIONS',
            scheme: 'library_unit'
          },
          'ce79271f-aeeb-42a0-bb7b-d945223aadce' => {
            id: 'GOVERNMENT_AND_GEOGRAPHIC_INFORMATION_COLLECTION',
            scheme: 'library_unit'
          },
          'd04a355d-a0d5-430e-a01f-1885142e6d93' => {
            id: 'MUSIC_LIBRARY',
            scheme: 'library_unit'
          },
          'fb560cc3-ea2b-41b0-bc0f-5e495c4f3f7f' => {
            id: 'HERSKOVITS_LIBRARY',
            scheme: 'library_unit'
          }
        }
      end

      def convert_coded_term_mapping(mapping, image)
        mapping.keys.flat_map do |field|
          image.attributes.fetch(field).map { |value| value.is_a?(String) ? authority_map.to_id(value) : value.id }.map { |id| mapping.fetch(field).merge(term: { id: id }) }
        end
      end

      def contributor_mapping
        {
          'architect' => {
            role: {
              id: 'arc',
              scheme: 'marc_relator'
            }
          },
          'artist' => {
            role: {
              id: 'art',
              scheme: 'marc_relator'
            }
          },
          'author' => {
            role: {
              id: 'aut',
              scheme: 'marc_relator'
            }
          },
          'cartographer' => {
            role: {
              id: 'ctg',
              scheme: 'marc_relator'
            }
          },
          'collector' => {
            role: {
              id: 'col',
              scheme: 'marc_relator'
            }
          },
          'compiler' => {
            role: {
              id: 'com',
              scheme: 'marc_relator'
            }
          },
          'composer' => {
            role: {
              id: 'cmp',
              scheme: 'marc_relator'
            }
          },
          'contributor' => {
            role: {
              id: 'ctb',
              scheme: 'marc_relator'
            }
          },
          'designer' => {
            role: {
              id: 'dsr',
              scheme: 'marc_relator'
            }
          },
          'director' => {
            role: {
              id: 'drt',
              scheme: 'marc_relator'
            }
          },
          'distributor' => {
            role: {
              id: 'dst',
              scheme: 'marc_relator'
            }
          },
          'donor' => {
            role: {
              id: 'dnr',
              scheme: 'marc_relator'
            }
          },
          'draftsman' => {
            role: {
              id: 'drm',
              scheme: 'marc_relator'
            }
          },
          'editor' => {
            role: {
              id: 'edt',
              scheme: 'marc_relator'
            }
          },
          'engraver' => {
            role: {
              id: 'egr',
              scheme: 'marc_relator'
            }
          },
          'illustrator' => {
            role: {
              id: 'ill',
              scheme: 'marc_relator'
            }
          },
          'librettist' => {
            role: {
              id: 'lbt',
              scheme: 'marc_relator'
            }
          },
          'musician' => {
            role: {
              id: 'mus',
              scheme: 'marc_relator'
            }
          },
          'nul_contributor' => {
            role: {
              id: 'ctb',
              scheme: 'marc_relator'
            }
          },
          'performer' => {
            role: {
              id: 'prf',
              scheme: 'marc_relator'
            }
          },
          'photographer' => {
            role: {
              id: 'pht',
              scheme: 'marc_relator'
            }
          },
          'presenter' => {
            role: {
              id: 'pre',
              scheme: 'marc_relator'
            }
          },
          'printer' => {
            role: {
              id: 'prt',
              scheme: 'marc_relator'
            }
          },
          'printmaker' => {
            role: {
              id: 'prm',
              scheme: 'marc_relator'
            }
          },
          'producer' => {
            role: {
              id: 'pro',
              scheme: 'marc_relator'
            }
          },
          'screenwriter' => {
            role: {
              id: 'aus',
              scheme: 'marc_relator'
            }
          },
          'sculptor' => {
            role: {
              id: 'scl',
              scheme: 'marc_relator'
            }
          },
          'sponsor' => {
            role: {
              id: 'spn',
              scheme: 'marc_relator'
            }
          },
          'transcriber' => {
            role: {
              id: 'trc',
              scheme: 'marc_relator'
            }
          }
        }
      end

      def subject_mapping
        {
          'subject' => {
            role: {
              id: 'TOPICAL',
              scheme: 'subject_role'
            }
          },
          'subject_geographical' => {
            role: {
              id: 'GEOGRAPHICAL',
              scheme: 'subject_role'
            }
          },
          'subject_topical' => {
            role: {
              id: 'TOPICAL',
              scheme: 'subject_role'
            }
          }
        }
      end

      def related_url_mapping(url)
        return nil if url.blank?

        case url
        when /findingaids/
          { label: { id: 'FINDING_AID', scheme: 'related_url' } }
        when /handle/
          { label: { id: 'HATHI_TRUST_DIGITAL_LIBRARY', scheme: 'related_url' } }
        when /libguides/
          { label: { id: 'RESEARCH_GUIDE', scheme: 'related_url' } }
        else
          { label: { id: 'RELATED_INFORMATION', scheme: 'related_url' } }
        end.merge(url: url)
      end

      class MeadowAuthorityMap
        def initialize(client)
          @client = client
          @authorities =
            CSV.parse(
              @client
                .get_object(
                  bucket: Settings.aws.buckets.export,
                  key: 'nul_authorities_export.csv'
                )
                .body
                .read
            )
        end

        def to_id(label)
          authorities.find do |authority|
            authority[1].casecmp(label.downcase).zero?
          end&.first
        end

        private

          attr_reader :authorities
      end
  end
end
