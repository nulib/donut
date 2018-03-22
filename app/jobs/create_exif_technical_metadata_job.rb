class CreateExifTechnicalMetadataJob < ApplicationJob
  def perform(file_set, file_path, strict: false)

    byebug
    exif_data = Exiftool.new(file_path, '-a -u -g1').to_hash
    populate_fields(exif_data, file_set)

    Rails.logger.info("done wow cool")
  end

  private

    def populate_fields(exif_data, fs)
      t = TechnicalMetadata.new
      # fs.image_width                       = exif_data[:ifd0]['ImageWidth']
      # fs.image_height                      = exif_data[:ifd0]['ImageHeight']
      # fs.compression                 = exif_data[:ifd0]['Compression']
      t.photometric_interpretation  << exif_data[:ifd0]['PhotometricInterpretation']
      t.samples_per_pixel           << exif_data[:ifd0]['SamplesPerPixel'] unless exif_data[:ifd0]['SamplesPerPixel'].blank?
      t.x_resolution                << exif_data[:ifd0]['XResolution'] unless exif_data[:ifd0]['XResolution'].blank?
      t.y_resolution                << exif_data[:ifd0]['YResolution'] unless exif_data[:ifd0]['YResolution'].blank?
      t.resolution_unit             << exif_data[:ifd0]['ResolutionUnit'] unless exif_data[:ifd0]['ResolutionUnit'].blank?
      t.date_time                   << exif_data[:'xmp-xmp']['CreateDate'] unless exif_data[:'xmp-xmp']['CreateDate'].blank?
      t.bits_per_sample             << exif_data[:ifd0]['BitsPerSample'] unless exif_data[:ifd0]['BitsPerSample'].blank?
      t.make                        << exif_data[:ifd0]['Make'] unless exif_data[:ifd0]['Make'].blank?
      t.model                       << exif_data[:ifd0]['Model'] unless exif_data[:ifd0]['Model'].blank?
      t.strip_offsets               << exif_data[:ifd0]['StripOffsets'] unless exif_data[:ifd0]['StripOffsets'].blank?
      t.rows_per_strip              << exif_data[:ifd0]['RowsPerStrip'] unless exif_data[:ifd0]['RowsPerStrip'].blank?
      t.strip_byte_counts           << exif_data[:ifd0]['StripByteCounts'] unless exif_data[:ifd0]['StripByteCounts'].blank?
      t.software                    << exif_data[:ifd0]['Software'] unless exif_data[:ifd0]['Software'].blank?
      # fs.artist                      =
      # fs.exif_tool_version           = exif_data[:exif_tool]['ExifToolVersion']
      t.extra_samples               << exif_data[:ifd0]['ExtraSamples'] unless exif_data[:ifd0]['ExtraSamples'].blank?
      # fs.exif_all_data               = exif_data
      t.save
      fs.members << t
    end
end
