require 'rails_helper'

RSpec.describe CreateExifTechnicalMetadataJob do
  subject(:job) { described_class.new }

  describe 'getting exif data' do
    it 'can run exif-tool against the tiff' do
      expect((job.send :get_exif_data, Rails.root.join('spec', 'fixtures', 'images', 'exif_fixture.tif')).class).to be(Hash)
    end

    describe 'retrieving required values' do
      let(:hash) { job.send :get_exif_data, Rails.root.join('spec', 'fixtures', 'images', 'exif_fixture.tif') }

      it 'gets the ifd0 exif values needed by the required fields' do
        expect(hash).to have_key(:ifd0)
      end

      it 'retrieves image width' do
        expect(hash.dig(:ifd0, 'ImageWidth')).not_to be_nil
      end

      it 'retrieves image height' do
        expect(hash.dig(:ifd0, 'ImageHeight')).not_to be_nil
      end

      it 'retrieves compression' do
        expect(hash.dig(:ifd0, 'Compression')).not_to be_nil
      end

      it 'retrieves photometric interpretation' do
        expect(hash.dig(:ifd0, 'PhotometricInterpretation')).not_to be_nil
      end
    end
  end
end
