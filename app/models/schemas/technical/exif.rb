
module Schemas
  module Technical
    module Exif
      extend ActiveSupport::Concern

      # rubocop:disable Metrics/BlockLength
      included do
        property :image_width, predicate: ::RDF::Vocab::EBUCore.width, multiple: false do |index|
          index.as :stored_searchable
        end

        property :image_height, predicate: ::RDF::Vocab::EBUCore.height, multiple: false do |index|
          index.as :stored_searchable
        end

        # TODO: Make my predicate ns012:compressionScheme
        property :compression, predicate: ::RDF::Vocab::EXIF.compression, multiple: false do |index|
          index.as :stored_searchable
        end

        # TODO: Make my predicate ns010:colorSpace
        property :photometric_interpretation, predicate: ::RDF::Vocab::EXIF.photometricInterpretation, multiple: false do |index|
          index.as :stored_searchable
        end

        property :samples_per_pixel, predicate: ::RDF::Vocab::EXIF.samplesPerPixel, multiple: false do |index|
          index.as :stored_searchable
        end

        property :x_resolution, predicate: ::RDF::Vocab::EXIF.xResolution, multiple: false do |index|
          index.as :stored_searchable
        end

        property :y_resolution, predicate: ::RDF::Vocab::EXIF.yResolution, multiple: false do |index|
          index.as :stored_searchable
        end

        property :resolution_unit, predicate: ::RDF::Vocab::EXIF.resolutionUnit, multiple: false do |index|
          index.as :stored_searchable
        end

        property :date_time, predicate: ::RDF::Vocab::EXIF.dateTime, multiple: false do |index|
          index.as :stored_searchable
        end

        property :bits_per_sample, predicate: ::RDF::Vocab::EXIF.bitsPerSample, multiple: false do |index|
          index.as :stored_searchable
        end

        property :make, predicate: ::RDF::Vocab::EXIF.make, multiple: false do |index|
          index.as :stored_searchable
        end

        property :model, predicate: ::RDF::Vocab::EXIF.model, multiple: false do |index|
          index.as :stored_searchable
        end

        property :strip_offsets, predicate: ::RDF::Vocab::EXIF.stripOffsets, multiple: false do |index|
          index.as :stored_searchable
        end

        property :rows_per_strip, predicate: ::RDF::Vocab::EXIF.rowsPerStrip, multiple: false do |index|
          index.as :stored_searchable
        end

        property :strip_byte_counts, predicate: ::RDF::Vocab::EXIF.stripByteCounts, multiple: false do |index|
          index.as :stored_searchable
        end

        property :software, predicate: ::RDF::Vocab::PREMIS.hasCreatingApplicationVersion, multiple: false do |index|
          index.as :stored_searchable
        end

        property :artist, predicate: ::RDF::Vocab::EXIF.artist, multiple: true do |index|
          index.as :stored_searchable
        end

        # I know the predicate is wrong, but i want to test some stuff out
        property :extra_samples, predicate: ::RDF::Vocab::EXIF.bitsPerSample, multiple: false do |index|
          index.as :stored_searchable
        end

        property :exif_tool_version, predicate: ::Vocab::Donut.exif_tool_version, multiple: false do |index|
          index.as :stored_searchable
        end

        property :exif_all_data, predicate: ::Vocab::Donut.exif_all_data, multiple: false do |index|
          index.as :stored_searchable
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end