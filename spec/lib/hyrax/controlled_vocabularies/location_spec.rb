require 'rails_helper'

RSpec.describe Hyrax::ControlledVocabularies::Location do
  let(:uri) { 'http://sws.geonames.org/5099836' }
  let(:resource) {  described_class.new(RDF::URI(uri)) }
  let(:cache_key) { "fetch:#{uri}" }
  let(:cache) { instance_double(ActiveSupport::Cache::Store) }
  let(:geo_triple) { file_fixture('5746545.ntz').read }

  before do
    allow(cache).to receive(:write).with(cache_key, anything)
    allow(Rails).to receive(:cache).and_return(cache)
    stub_request(:get, resource.rdf_subject.to_s).to_return(status: 200, body: file_fixture('5746545.nt').read)
  end

  describe '.geo_point' do
    before do
      allow(cache).to receive(:read).with(cache_key).and_return(geo_triple)
    end

    it 'returns the latitdue and longitude' do
      result = resource.geo_point
      expect(result).to eq(lat: '45.52345', lon: '-122.67621')
    end
  end
end
