class CreateExifTechnicalMetadataJob < ApplicationJob
  def perform(file_set, file_path)
    exif_data = get_exif_data(file_path)
    populate_tech_md(exif_data, file_set)
  end

  private

    # Calls the Vendored Exif Tool with appriorate arguments and returns the hash
    def get_exif_data(file_path)
      Exiftool.new(file_path, '-a -u -g1').to_hash
    end

    def populate_tech_md(exif_data, fs)
      made_new_tech_md = false
      t = fs.technical_metadata
      if t.nil?
        t = TechnicalMetadata.new
        made_new_tech_md = true
      end
      t = populate_fields(t, exif_data, fs.id)
      fs.members << t if made_new_tech_md # if we made a new techMD add it as a member
      fs.update_index
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def populate_fields(t, exif_data, file_set_id)
      t.image_width                 = exif_data.dig(:ifd0, 'ImageWidth').to_s
      t.image_height                = exif_data.dig(:ifd0, 'ImageHeight').to_s
      t.compression                 = exif_data.dig(:ifd0, 'Compression').to_s
      t.photometric_interpretation  = exif_data.dig(:ifd0, 'PhotometricInterpretation').to_s
      t.samples_per_pixel           = exif_data.dig(:ifd0, 'SamplesPerPixel').to_s if exif_data.dig(:ifd0, 'SamplesPerPixel').present?
      t.x_resolution                = exif_data.dig(:ifd0, 'XResolution').to_s if exif_data.dig(:ifd0, 'XResolution').present?
      t.y_resolution                = exif_data.dig(:ifd0, 'YResolution').to_s if exif_data.dig(:ifd0, 'YResolution').present?
      t.resolution_unit             = exif_data.dig(:ifd0, 'ResolutionUnit').to_s if exif_data.dig(:ifd0, 'ResolutionUnit').present?
      t.date_time                   = exif_data.dig(:'xmp-xmp', 'CreateDate').to_s if exif_data.dig(:'xmp-xmp', 'CreateDate').present?
      t.bits_per_sample             = exif_data.dig(:ifd0, 'BitsPerSample').to_s if exif_data.dig(:ifd0, 'BitsPerSample').present?
      t.make                        = exif_data.dig(:ifd0, 'Make').to_s if exif_data.dig(:ifd0, 'Make').present?
      t.model                       = exif_data.dig(:ifd0, 'Model').to_s if exif_data.dig(:ifd0, 'Model').present?
      t.strip_offsets               = exif_data.dig(:ifd0, 'StripOffsets').to_s if exif_data.dig(:ifd0, 'StripOffsets').present?
      t.rows_per_strip              = exif_data.dig(:ifd0, 'RowsPerStrip').to_s if exif_data.dig(:ifd0, 'RowsPerStrip').present?
      t.strip_byte_counts           = exif_data.dig(:ifd0, 'StripByteCounts').to_s if exif_data.dig(:ifd0, 'StripByteCounts').present?
      t.software                    = exif_data.dig(:ifd0, 'Software').to_s if exif_data.dig(:ifd0, 'Software').present?
      # fs.artist                      =
      t.exif_tool_version           = exif_data.dig(:exif_tool, 'ExifToolVersion').to_s
      t.extra_samples               = exif_data.dig(:ifd0, 'ExtraSamples').to_s if exif_data.dig(:ifd0, 'ExtraSamples').present?
      t.exif_all_data               = exif_data.to_json
      t.file_set_id                 = file_set_id
      t.save
      t
    end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/PerceivedComplexity
