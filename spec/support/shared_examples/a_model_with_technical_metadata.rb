# rubocop:disable Metrics/BlockLength

RSpec.shared_examples 'a model with technical metadata' do
  it { is_expected.to have_editable_property(:image_width, ::RDF::Vocab::EBUCore.width) }
  it { is_expected.to have_editable_property(:image_height, ::RDF::Vocab::EBUCore.height) }
  it { is_expected.to have_editable_property(:compression, ::RDF::Vocab::EXIF.compression) }
  it { is_expected.to have_editable_property(:photometric_interpretation, ::RDF::Vocab::EXIF.photometricInterpretation) }
  it { is_expected.to have_editable_property(:samples_per_pixel, ::RDF::Vocab::EXIF.samplesPerPixel) }
  it { is_expected.to have_editable_property(:x_resolution, ::RDF::Vocab::EXIF.xResolution) }
  it { is_expected.to have_editable_property(:y_resolution, ::RDF::Vocab::EXIF.yResolution) }
  it { is_expected.to have_editable_property(:resolution_unit, ::RDF::Vocab::EXIF.resolutionUnit) }
  it { is_expected.to have_editable_property(:date_time, ::RDF::Vocab::EXIF.dateTime) }
  it { is_expected.to have_editable_property(:bits_per_sample, ::RDF::Vocab::EXIF.bitsPerSample) }
  it { is_expected.to have_editable_property(:make, ::RDF::Vocab::EXIF.make) }
  it { is_expected.to have_editable_property(:model, ::RDF::Vocab::EXIF.model) }
  it { is_expected.to have_editable_property(:strip_offsets, ::RDF::Vocab::EXIF.stripOffsets) }
  it { is_expected.to have_editable_property(:rows_per_strip, ::RDF::Vocab::EXIF.rowsPerStrip) }
  it { is_expected.to have_editable_property(:strip_byte_counts, ::RDF::Vocab::EXIF.stripByteCounts) }
  it { is_expected.to have_editable_property(:software, ::RDF::Vocab::PREMIS.hasCreatingApplicationVersion) }
  # it { is_expected.to have_editable_property(:artist, ::RDF::Vocab::EXIF.artist) }
  it { is_expected.to have_editable_property(:extra_samples, ::RDF::Vocab::EXIF.bitsPerSample) }
  it { is_expected.to have_editable_property(:exif_tool_version, ::Vocab::Donut.exif_tool_version) }
  it { is_expected.to have_editable_property(:exif_all_data, ::Vocab::Donut.exif_all_data) }
end
# rubocop:enable Metrics/BlockLength
