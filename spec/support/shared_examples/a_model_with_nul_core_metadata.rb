RSpec.shared_examples 'a model with nul core metadata' do
  it { is_expected.to have_editable_property(:keyword, RDF::Vocab::SCHEMA.keywords) }
  it { is_expected.to have_editable_property(:language, RDF::Vocab::DC11.language) }
end
