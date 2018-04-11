require 'rails_helper'

RSpec.describe Donut::CharacterizationService do
  let(:file) { Hydra::PCDM::File.new }
  let(:all_data) { JSON.parse(file.exif_all_data.first) }
  let(:test_value) { all_data['ifd0']['SubfileType'] }

  before do
    described_class.run(file, 'test1234')
  end

  # rubocop:disable RSpec/ExampleLength
  it 'assigns expected values to characterized properties.' do
    expect(file.photometric_interpretation).to eq ['RGB']
    expect(file.samples_per_pixel).to eq [3]
    expect(file.x_resolution).to eq [600]
    expect(file.y_resolution).to eq [600]
    expect(file.resolution_unit).to eq ['inches']
    expect(file.date_time).to eq ['2014:07:16 10:26:11']
    expect(file.bits_per_sample).to eq ['8 8 8']
    expect(file.make).to eq ['i2S, Corp.']
    expect(file.strip_offsets).to eq [34_612]
    expect(file.rows_per_strip).to eq [6212]
    expect(file.strip_byte_counts).to eq [102_125_280]
    expect(file.donut_exif_version).to eq [10.65]
  end
  # rubocop:enable RSpec/ExampleLength

  it 'stores the raw exif output' do
    expect(all_data).to be_a(Hash)
    expect(test_value).to eq 'Full-resolution Image'
  end
end
