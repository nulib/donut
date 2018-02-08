RSpec.shared_examples 'a model with hyrax basic metadata' do
  it { is_expected.to have_editable_property(:based_near, RDF::Vocab::FOAF.based_near) }
  it { is_expected.to have_editable_property(:contributor, RDF::Vocab::DC11.contributor) }
  it { is_expected.to have_editable_property(:creator, RDF::Vocab::DC11.creator) }
  it { is_expected.to have_editable_property(:depositor, RDF::Vocab::MARCRelators.dpt) }
  it { is_expected.to have_editable_property(:description, RDF::Vocab::DC11.description) }
  it { is_expected.to have_editable_property(:keyword, RDF::Vocab::DC11.relation) }
  it { is_expected.to have_editable_property(:language, RDF::Vocab::DC11.language) }
  it { is_expected.to have_editable_property(:license, RDF::Vocab::DC.rights) }
  it { is_expected.to have_editable_property(:publisher, RDF::Vocab::DC11.publisher) }
  it { is_expected.to have_editable_property(:related_url, RDF::RDFS.seeAlso) }
  it { is_expected.to have_editable_property(:rights_statement, RDF::Vocab::EDM.rights) }
  it { is_expected.to have_editable_property(:title, RDF::Vocab::DC.title) }
end
