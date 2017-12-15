require 'rails_helper'
require 'importer'
require 'aws-sdk'

RSpec.describe Importer::CSVImporter do
  let(:bucket) { 'buckett' }
  let(:csv_file_key) { 'sample.csv' }
  let(:csv) { Aws::S3::Client.new.get_object(bucket: bucket, key: csv_file_key).body.read }
  let(:csv_resource) { Aws::S3::Object.new(client: Aws::S3::Client.new, bucket_name: bucket, key: csv_file_key) }

  context 'when the model specified on the row' do
    let(:importer) { described_class.new(csv, csv_resource) }
    let(:collection_factory) { double }
    let(:image_factory) { double }
    let(:collection_spy) { instance_spy(collection_factory) }

    before do
      create(:user)
      allow(Importer::Factory::ImageFactory).to receive(:new).with(any_args).and_return(collection_factory)
      allow(collection_factory).to receive(:run)
    end

    it 'creates new images and collections' do
      importer.import_all
      expect(Importer::Factory::ImageFactory).to have_received(:new)
        .with(hash_excluding(:type), csv_resource)
      expect(collection_factory).to have_received(:run)
    end
  end
end
