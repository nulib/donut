require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SolrDocument do
  subject { SolrDocument.new({}) }

  it 'has no metatdata initially' do
    expect(subject.title).to_be empty
    expect(subject.abstract).to_be empty
    expect(subject.accession_number).to_be empty
    expect(subject.call_number).to_be empty
    expect(subject.catalog_key).to_be empty
    expect(subject.citation).to_be empty
    expect(subject.contributor_role).to_be empty
    expect(subject.creator_attribution).to_be empty
    expect(subject.creator_role).to_be empty
    expect(subject.genre).to_be empty
    expect(subject.physical_description).to_be empty
    expect(subject.related_url_label).to_be empty
    expect(subject.rights_holder).to_be empty
    expect(subject.style_period).to_be empty
    expect(subject.technique).to_be empty
  end

  context 'with complete metadata' do
    let(:image) { FactoryGirl.create(:image) }

    subject { SolrDocument.new(image.to_solr) }

    it 'contains metatdata' do
      expect(subject.title).to contain_exactly('Test title')
      expect(subject.abstract).to contain_exactly('Lemon drops donut gummi bears carrot cake dragée. Toffee bonbon sesame snaps powder. Carrot cake dragée chupa chups gingerbread lollipop marzipan pudding oat cake dessert. Tiramisu cake macaroon sesame snaps cookie croissant pie chocolate bar. Sweet liquorice halvah toffee tootsie roll. Lollipop carrot cake bonbon dragée dragée icing carrot cake cheesecake chocolate cake.')
      expect(subject.accession_number).to contain_exactly('Lgf0825')
      expect(subject.call_number).to contain_exactly('W107.8:Am6')
      expect(subject.catalog_key).to contain_exactly('9943338434202441')
      expect(subject.citation).to contain_exactly('Test')
      expect(subject.contributor_role).to contain_exactly('Joanne	Howell')
      expect(subject.creator_attribution).to contain_exactly('Unknown')
      expect(subject.creator_role).to contain_exactly('http://id.loc.gov/vocabulary/relators/ill.html')
      expect(subject.genre).to contain_exactly('Postmodern')
      expect(subject.physical_description).to contain_exactly('Wood 6cm x 7cm')
      expect(subject.related_url_label).to contain_exactly('Related Website')
      expect(subject.rights_holder).to contain_exactly('Northwestern University Libraries')
      expect(subject.style_period).to contain_exactly('Renaissance')
      expect(subject.technique).to contain_exactly('Test title')
    end
  end
end
# rubocop:enable Metrics/BlockLength
