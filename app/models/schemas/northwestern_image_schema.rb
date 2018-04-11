module Schemas
  class NorthwesternImageSchema < ActiveTriples::Schema
    property :photometric_interpretation, predicate: ::RDF::Vocab::EXIF.photometricInterpretation
    property :samples_per_pixel, predicate: ::RDF::Vocab::EXIF.samplesPerPixel
    property :x_resolution, predicate: ::RDF::Vocab::EXIF.xResolution
    property :y_resolution, predicate: ::RDF::Vocab::EXIF.yResolution
    property :resolution_unit, predicate: ::RDF::Vocab::EXIF.resolutionUnit
    property :date_time, predicate: ::RDF::Vocab::EXIF.dateTime
    property :bits_per_sample, predicate: ::RDF::Vocab::EXIF.bitsPerSample
    property :make, predicate: ::RDF::Vocab::EXIF.make
    property :strip_offsets, predicate: ::RDF::Vocab::EXIF.stripOffsets
    property :rows_per_strip, predicate: ::RDF::Vocab::EXIF.rowsPerStrip
    property :strip_byte_counts, predicate: ::RDF::Vocab::EXIF.stripByteCounts
    property :artist, predicate: ::RDF::Vocab::EXIF.artist
    property :donut_exif_version, predicate: ::Vocab::Donut.donut_exif_version
    property :exif_all_data, predicate: ::Vocab::Donut.exif_all_dat
  end
end
