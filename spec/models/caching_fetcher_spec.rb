require 'rails_helper'

RSpec.describe CachingFetcher do
  let(:klass) do
    Class.new(ControlledVocabularies::Base) do
      include CachingFetcher
    end
  end
  let(:uri) { 'http://vocab.getty.edu/aat/300120209' }
  let(:resource) { klass.new(RDF::URI(uri)) }
  let(:cache_key) { "fetch:#{uri}" }
  let(:cache) { instance_double(ActiveSupport::Cache::Store) }

  before do
    allow(cache).to receive(:write).with(cache_key, anything)
    allow(Rails).to receive(:cache).and_return(cache)
    stub_request(:get, resource.rdf_subject.to_s).to_return(status: 200, body: file_fixture('300120209.nt').read)
  end

  context 'cache miss' do
    before do
      allow(cache).to receive(:read).with(cache_key).and_return(nil)
      resource.fetch
    end

    it 'misses the cache' do
      expect(cache).to have_received(:write)
    end

    it 'has the right data' do
      expect(resource.preferred_label.to_s).to eq('Angkorean')
    end
  end

  context 'cache hit' do
    before do
      allow(cache).to receive(:read).with(cache_key).and_return(file_fixture('300120209.ntz').read)
      resource.fetch
    end

    it 'hits the cache' do
      expect(cache).not_to have_received(:write)
    end

    it 'has the right data' do
      expect(resource.preferred_label.to_s).to eq('Angkorean')
    end
  end
end
