# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImagePresenter, type: :unit do
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

  subject { described_class.new(solr_document, ability, request) }

  it { expect(subject.title).to eq ['Blue'] }
  it { expect(subject.depositor).to eq 'abc123' }
  it { expect(subject.description).to eq ['cyan and turqoise image'] }
  it { expect(subject.creator).to eq ['Same Person'] }
end
