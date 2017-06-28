require 'iiif_manifest'
require 'rails_helper'

RSpec.describe FileSetPresenter do
  let(:file_set) { FactoryGirl.create(:file_set) }
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:request) { instance_double('Rack::Request::Helpers', base_url: 'http://test.host') }
  let(:presenter) { described_class.new(solr_document, nil, request) }
  let(:id) { CGI.escape(file_set.original_file.id) }

  before do
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        File.open(fixture_path + '/images/world.png'),
                                        :original_file)
  end

  describe 'display_image' do
    subject(:display_image) { presenter.display_image }

    it 'creates a display image' do
      expect(display_image).to be_instance_of IIIFManifest::DisplayImage
      expect(display_image.url).to eq "http://test.host/images/#{id}/full/600,/0/default.jpg"
    end
  end

  describe 'iiif_endpoint' do
    subject(:endpoint) { presenter.send(:iiif_endpoint, file_set.original_file) }

    it 'returns the url' do
      expect(endpoint.url).to eq "http://test.host/images/#{id}"
    end
  end
end
