# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImagePresenter, type: :unit do
  subject(:presenter) { described_class.new(solr_document, ability, request) }

  let(:image) { FactoryBot.create(:image) }

  let(:solr_document) { SolrDocument.new(image.to_solr) }
  let(:ability)       { Ability.new(nil) }
  let(:request)       { nil }

  it { expect(presenter.title).to eq ['Test title'] }
  it { expect(presenter.alternate_title).to eq ['Alternate Title 1'] }
  it { expect(presenter.rights_statement).to eq ['http://rightsstatements.org/vocab/NKC/1.0/'] }
  it { expect(presenter.description).to eq ['Test description'] }
  it { expect(presenter.abstract).to eq ['Lemon drops donut gummi bears carrot cake.'] }
  it { expect(presenter.accession_number).to eq ['Lgf0825'] }
  it { expect(presenter.ark).to eq ['ark:/12345/12345'] }
  it { expect(presenter.call_number).to eq ['W107.8:Am6'] }
  it { expect(presenter.caption).to eq ['This is the caption seen on the image'] }
  it { expect(presenter.catalog_key).to eq ['9943338434202441'] }
  it { expect(presenter.citation).to eq ['Test'] }
  it { expect(presenter.contributor_role).to eq ['Joanne	Howell'] }
  it { expect(presenter.creator_role).to eq ['http://id.loc.gov/vocabulary/relators/ill.html'] }
  it { expect(presenter.genre).to eq ['Postmodern'] }
  it { expect(presenter.provenance).to eq ['The example provenance'] }
  it { expect(presenter.physical_description).to eq ['Wood 6cm x 7cm'] }
  it { expect(presenter.related_url_label).to eq ['Related Website'] }
  it { expect(presenter.rights_holder).to eq ['Northwestern University Libraries'] }
  it { expect(presenter.style_period_label).to eq ['Renaissance'] }
  it { expect(presenter.technique).to eq ['Gauche'] }
end
