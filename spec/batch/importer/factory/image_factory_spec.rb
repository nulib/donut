require 'rails_helper'
require 'importer'

RSpec.describe Importer::Factory::ImageFactory, :clean, admin_set: true do
  let(:factory) { described_class.new(attributes) }
  let(:actor) { instance_spy('actor') }
  let(:bucket) { Settings.aws.buckets.batch }
  let(:csv_file_key) { 'sample.csv' }
  let(:csv_resource) { Aws::S3::Object.new(client: Aws::S3::Client.new, bucket_name: bucket, key: csv_file_key) }
  let(:attributes) do
    {
      collections: [{ id: coll.id }],
      file: ['files/coffee.jpg'],
      identifier: ['123'],
      title: ['Test image']
    }
  end

  before do
    allow(Hyrax::CurationConcern).to receive(:actor).and_return(actor)
  end

  context 'with files' do
    let(:factory) { described_class.new(attributes, csv_resource) }
    let!(:coll) { create(:collection) }

    context 'for a new image' do
      it 'creates file sets with access controls' do
        factory.run
        expect(actor).to have_received(:create).with(Hyrax::Actors::Environment) do |k|
          expect(k.attributes).to include(member_of_collections: [coll])
          expect(k.attributes[:remote_files].first[:url]).to include("#{Settings.aws.buckets.batch}/files/coffee.jpg")
        end
      end
    end

    context 'with an admin set' do
      let(:factory) { described_class.new(attributes.merge(admin_set_id: 'batch-test'), csv_resource) }

      it 'can add to admin sets' do
        factory.run
        expect(actor).to have_received(:create).with(Hyrax::Actors::Environment) do |k|
          expect(k.attributes).to include(admin_set_id: 'batch-test')
        end
      end
    end

    context 'for an existing image without files' do
      let(:work) { create(:image) }
      let(:factory) { described_class.new(attributes.merge(id: work.id), csv_resource) }

      it 'creates file sets' do
        factory.run
        expect(actor).to have_received(:update).with(Hyrax::Actors::Environment) do |k|
          expect(k.attributes).to include(member_of_collections: [coll])
          expect(k.attributes[:remote_files].first[:url]).to include("#{Settings.aws.buckets.batch}/files/coffee.jpg")
        end
      end
    end
  end

  context 'when a collection already exists' do
    let!(:coll) { create(:collection) }
    let(:factory) { described_class.new(attributes, csv_resource) }

    it 'does not create a new collection' do
      expect { factory.run }.to change { Collection.count }.by(0)
      expect(actor).to have_received(:create).with(Hyrax::Actors::Environment) do |k|
        expect(k.attributes).to include(member_of_collections: [coll])
      end
    end
  end
end
