RSpec.shared_examples 'a model with nul core metadata' do
  it { is_expected.to have_editable_property(:contributor, RDF::Vocab::DC11.contributor) }
  it { is_expected.to have_editable_property(:creator, RDF::Vocab::DC11.creator) }
  it { is_expected.to have_editable_property(:keyword, RDF::Vocab::SCHEMA.keywords) }
  it { is_expected.to have_editable_property(:language, RDF::Vocab::DC.language) }
  it { is_expected.to have_editable_property(:license, RDF::Vocab::DC.license) }
end
