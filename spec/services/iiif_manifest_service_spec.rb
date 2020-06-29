require 'rails_helper'

RSpec.describe IiifManifestService do
  let(:attributes) { { id: 'abc123' } }
  let(:ability) { S3ManifestAbility.new }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:presenter) { S3IiifManifestPresenter.new(solr_document, ability) }
  let(:manifest_path) { "#{fixture_path}/files/manifest.json" }
  let(:bucket) { Aws::S3::Bucket.new(Settings.aws.buckets.manifests) }
  let(:instance) { described_class }

  context 'write to S3' do
    before do
      allow(IIIFManifest::ManifestFactory).to receive(:new).and_return(JSON.parse(File.read(manifest_path)))
      allow(SolrDocument).to receive(:find).with(presenter.id).and_return(solr_document)
    end
    let(:instance) { described_class }

    describe '.manifest_url' do
      it 'returns a string' do
        work_id = 'e5942432-cfd1-46f0-ba44-67d5fdd2b6e0'
        manifest_url = "#{Settings.metadata.endpoint}public/e5/94/24/32/-c/fd/1-/46/f0/-b/a4/4-/67/d5/fd/d2/b6/e0-manifest.json"
        expect(instance.manifest_url(work_id)).to eq(manifest_url)
      end
    end

    describe '.write_manifest' do
      before do
        allow(IIIFManifest::ManifestFactory).to receive(:new).and_return(JSON.parse(File.read(manifest_path)))
        allow(SolrDocument).to receive(:find).with(presenter.id).and_return(solr_document)
      end

      it 'writes manifests to the store' do
        expect { instance.write_manifest(presenter.id) }.to change { bucket.objects.count }.by(1)
      end
    end

    describe '.write_manifest when work is restricted' do
      let(:attributes) { { id: 'abc123', visibility_ssi: 'restricted' } }

      it 'does not write a manifest to the store' do
        expect { instance.write_manifest(presenter.id) }.not_to(change { bucket.objects.count })
      end
    end
  end
end
