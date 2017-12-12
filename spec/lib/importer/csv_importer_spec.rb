require 'rails_helper'
require 'importer'
require 'aws-sdk'

RSpec.describe Importer::CSVImporter do
  let(:bucket) { 'test-1234' }
  let(:csv_file_key) { 'sample.csv' }
  let(:csv) { Aws::S3::Client.new.get_object(bucket: bucket, key: csv_file_key).body.read }
  let(:csv_resource) { Aws::S3::Object.new(client: Aws::S3::Client.new, bucket_name: bucket, key: csv_file_key) }

  context 'when the model specified on the row' do
    let(:importer) { described_class.new(csv, csv_resource) }
    let(:collection_factory) { double }
    let(:image_factory) { double }

    # rubocop:disable RSpec/MessageSpies
    it 'creates new images and collections' do
      expect(Importer::Factory::ImageFactory).to receive(:new)
        .with(hash_excluding(:type), csv_resource)
        .and_return(collection_factory)
      expect(collection_factory).to receive(:run)
      importer.import_all
    end
    # rubocop:enable RSpec/MessageSpies
  end
end
