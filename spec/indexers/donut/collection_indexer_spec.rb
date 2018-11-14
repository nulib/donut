require 'rails_helper'

RSpec.describe Donut::CollectionIndexer do
  let(:indexer) { TestIndexer.new(collection) }
  let(:collection) { build(:collection, attributes) }
  let(:iiif_url) { 'http://localhost:8183/iiif/2/f8%2F6e%2Fb9%2Fd5%2F-9%2F10%2Fb-%2F4c%2F7b%2F-8%2F10%2F5-%2F5a%2Fd0%2Fa2%2F05%2Ff4%2Fe9' }
  let(:doc) do
    {
      'thumbnail_iiif_url_ss' => iiif_url
    }
  end

  before do
    class TestIndexer < Donut::CollectionIndexer
      attr_reader :object

      def initialize(collection)
        @object = collection
      end
    end
  end

  after do
    Object.send(:remove_const, :TestIndexer)
  end

  describe '#generate_solr_document' do
    before do
      allow(indexer).to receive(:thumbnail_iiif_url).and_return(iiif_url)
    end

    context 'with thumbnail_id present' do
      subject(:solr_doc) { indexer.generate_solr_document }

      let(:attributes) { { thumbnail_id: 'yes' } }

      it 'has the iiif thumbnail url' do
        expect(solr_doc).to match a_hash_including(doc)
      end
    end

    context 'without thumbnail_id present' do
      subject(:solr_doc) { indexer.generate_solr_document }

      let(:attributes) { {} }

      it 'does not have the iiif thumbnail url' do
        expect(solr_doc).not_to include('thumbnail_iiif_url_ss')
      end
    end
  end
end
