# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImagePresenter, type: :unit do
  subject(:presenter) { described_class.new(solr_document, ability, request) }

  let(:image) do
    Image.new.tap do |image|
      image.id = 'image-id'
      image.title = ['Blue']
      image.depositor = 'abc123'
      image.description = ['cyan and turqoise image']
      image.creator = ['Same Person']
    end
  end

  let(:solr_document) { SolrDocument.new(image.to_solr) }
  let(:ability)       { Ability.new(nil) }
  let(:request)       { nil }

  it { expect(presenter.title).to eq ['Blue'] }
  it { expect(presenter.depositor).to eq 'abc123' }
  it { expect(presenter.description).to eq ['cyan and turqoise image'] }
  it { expect(presenter.creator).to eq ['Same Person'] }
end
