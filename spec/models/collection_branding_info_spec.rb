require 'rails_helper'

RSpec.describe CollectionBrandingInfo do
  let(:banner_info) do
    described_class.new(
      collection_id: 'test-collection-id',
      filename: 'world.png',
      role: 'banner',
      alt_txt: 'banner alt txt',
      target_url: ''
    )
  end

  describe 'save banner and logo info' do
    before do
      allow(File).to receive(:exist?).and_return(true)
      allow(FileUtils).to receive(:remove_file)
    end

    it 'populates the banner class, moves image to s3, and cleans up tempfile' do
      banner_info.save("#{fixture_path}/images/world.png")
      expect(FileUtils).to have_received(:remove_file).with("#{fixture_path}/images/world.png")
      expect(banner_info.local_path).to eq('test-collection-id/banner/world.png')
    end
  end

  describe 'remove banner/logo files from s3' do
    # rubocop:disable RSpec/AnyInstance
    it 'removes banner file from public directory' do
      expect_any_instance_of(Aws::S3::Object).to receive(:delete)
      banner_info.destroy
    end
    # rubocop:enable RSpec/AnyInstance
  end
end
