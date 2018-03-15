# frozen_string_literal: true

module Schemas
  ##
  # Schema for Donut technical metadata
  #
  # @example applying the technical schema
  #
  #   class WorkType < ActiveFedora::Base
  #     include ::Hyrax::WorkBehavior
  #     include ::Schemas::Technical
  #     include ::Hyrax::BasicMetadata
  #   end
  #
  # @see ActiveFedora::Base
  # @see Hyrax::WorkBehavior
  module Technical
    module Exif
      extend ActiveSupport::Concern

      included do
        property :image_width, predicate: ::RDF::Vocab::EBUCore.width, multiple: false do |index|
          index.as :stored_searchable
        end

        property :image_height, predicate: ::RDF::Vocab::EBUCore.height, multiple: false do |index|
          index.as :stored_searchable
        end

        property :compression, predicate: ::RDF::Vocab::EXIF.compression, multiple: true do |index|
          index.as :stored_searchable
        end

        property :photometric_interpretation, predicate: ::RDF::Vocab::EXIF.photometricInterpretation, multiple: true do |index|
          index.as :stored_searchable
        end

        property :samples_per_pixel, predicate: ::RDF::Vocab::EXIF.samplesPerPixel, multiple: true do |index|
          index.as :stored_searchable
        end

        property :x_resolution, predicate: ::RDF::Vocab::EXIF.xResolution do |index|
          index.as :stored_searchable
        end

        property :y_resolution, predicate: ::RDF::Vocab::EXIF.yResolution do |index|
          index.as :stored_searchable
        end

        property :resolution_unit, predicate: ::RDF::Vocab::EXIF.resolutionUnit do |index|
          index.as :stored_searchable
        end

        property :date_time, predicate: ::RDF::Vocab::EXIF.dateTime do |index|
          index.as :stored_searchable
        end

        property :bits_per_sample, predicate: ::RDF::Vocab::EXIF.bitsPerSample, multiple: true do |index|
          index.as :stored_searchable
        end

        property :make, predicate: ::RDF::Vocab::EXIF.make do |index|
          index.as :stored_searchable
        end

        property :model, predicate: ::RDF::Vocab::EXIF.model do |index|
          index.as :stored_searchable
        end

        property :strip_offsets, predicate: ::RDF::Vocab::EXIF.stripOffsets, multiple: true do |index|
          index.as :stored_searchable
        end

        property :rows_per_strip, predicate: ::RDF::Vocab::EXIF.rowsPerStrip, multiple: true do |index|
          index.as :stored_searchable
        end

        property :strip_byte_counts, predicate: ::RDF::Vocab::EXIF.stripByteCounts, multiple: true do |index|
          index.as :stored_searchable
        end

        property :software, predicate: ::RDF::Vocab::PREMIS.hasCreatingApplicationVersion, multiple: true do |index|
          index.as :stored_searchable
        end

        property :artist, predicate: ::RDF::Vocab::EXIF.artist, multiple: true do |index|
          index.as :stored_searchable
        end

        # I know the predicate is wrong, but i want to test some stuff out
        property :extra_samples, predicate: ::RDF::Vocab::EXIF.bitsPerSample, multiple: true do |index|
          index.as :stored_searchable
        end

        property :exif_tool_version, predicate: ::RDF::Vocab::EXIF.exifVersion do |index|
            index.as :stored_searchable
        end

        property :exif_all_data, predicate: ::Vocab::Donut.exif_all do |index|
            index.as :stored_searchable
        end
      end
    end
  end
end
