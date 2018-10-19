require 'rails_helper'

RSpec.describe IiifManifestService do
  let(:attributes) { { id: 'abc123' } }
  let(:ability) { S3ManifestAbility.new }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:presenter) { S3IiifManifestPresenter.new(solr_document, ability) }
  let(:manifest_path) { "#{fixture_path}/files/manifest.json" }
  let(:bucket) { Aws::S3::Bucket.new(Settings.aws.buckets.manifests) }

  context 'writes to S3' do
    before do
      allow(IIIFManifest::ManifestFactory).to receive(:new).and_return(JSON.parse(File.read(manifest_path)))
      allow(SolrDocument).to receive(:find).with(presenter.id).and_return(solr_document)
    end
    let(:instance) { described_class }

    describe '.write_manifest' do
      it 'writes manifests to the store' do
        expect { instance.write_manifest(presenter.id) }.to change { bucket.objects.count }.by(1)
      end
    end
  end
end
