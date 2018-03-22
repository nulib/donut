class CreateExifTechnicalMetadataJob < ApplicationJob
  def perform(file_set, file_path, strict: false)

    exif_data = Exiftool.new(file_path, '-a -u -g1').to_hash
    populate_fields(exif_data, file_set)

    # Rails.logger.info("done wow cool")
  end

  private

    def populate_fields(exif_data, fs)
      t = TechnicalMetadata.new
      t.image_width            << exif_data[:ifd0]['ImageWidth'].to_s
      t.image_height                << exif_data[:ifd0]['ImageHeight'].to_s
      t.compression                 << exif_data[:ifd0]['Compression'].to_s
      t.photometric_interpretation  << exif_data[:ifd0]['PhotometricInterpretation'].to_s
      t.samples_per_pixel           << exif_data[:ifd0]['SamplesPerPixel'].to_s unless exif_data[:ifd0]['SamplesPerPixel'].blank?
      t.x_resolution                << exif_data[:ifd0]['XResolution'].to_s unless exif_data[:ifd0]['XResolution'].blank?
      t.y_resolution                << exif_data[:ifd0]['YResolution'].to_s unless exif_data[:ifd0]['YResolution'].blank?
      t.resolution_unit             << exif_data[:ifd0]['ResolutionUnit'].to_s unless exif_data[:ifd0]['ResolutionUnit'].blank?
      t.date_time                   << exif_data[:'xmp-xmp']['CreateDate'].to_s unless exif_data[:'xmp-xmp']['CreateDate'].blank?
      t.bits_per_sample             << exif_data[:ifd0]['BitsPerSample'].to_s unless exif_data[:ifd0]['BitsPerSample'].blank?
      t.make                        << exif_data[:ifd0]['Make'].to_s unless exif_data[:ifd0]['Make'].blank?
      t.model                       << exif_data[:ifd0]['Model'].to_s unless exif_data[:ifd0]['Model'].blank?
      t.strip_offsets               << exif_data[:ifd0]['StripOffsets'].to_s unless exif_data[:ifd0]['StripOffsets'].blank?
      t.rows_per_strip              << exif_data[:ifd0]['RowsPerStrip'].to_s unless exif_data[:ifd0]['RowsPerStrip'].blank?
      t.strip_byte_counts           << exif_data[:ifd0]['StripByteCounts'].to_s unless exif_data[:ifd0]['StripByteCounts'].blank?
      t.software                    << exif_data[:ifd0]['Software'].to_s unless exif_data[:ifd0]['Software'].blank?
      # fs.artist                      =
      t.exif_tool_version          << exif_data[:exif_tool]['ExifToolVersion'].to_s
      t.extra_samples               << exif_data[:ifd0]['ExtraSamples'].to_s unless exif_data[:ifd0]['ExtraSamples'].blank?
      t.exif_all_data              << exif_data.to_json
      t.file_set_id                 = fs.id
      t.save
      fs.members << t
      fs.update_index
    end
end
