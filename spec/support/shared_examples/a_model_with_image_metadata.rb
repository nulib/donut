RSpec.shared_examples 'a model with image metadata' do
  it { is_expected.to have_editable_property(:accession_number, 'http://id.loc.gov/vocabulary/subjectSchemes/local') }
  it { is_expected.to have_editable_property(:abstract, RDF::Vocab::DC.abstract) }
  it { is_expected.to have_editable_property(:alternate_title, RDF::Vocab::DC.alternative) }
  it { is_expected.to have_editable_property(:ark, RDF::Vocab::DataCite.ark) }
  it { is_expected.to have_editable_property(:call_number, RDF::Vocab::Bibframe.shelfMark) }
  it { is_expected.to have_editable_property(:caption, RDF::Vocab::SCHEMA.caption) }
  it { is_expected.to have_editable_property(:catalog_key, 'http://www.w3.org/2002/07/owl#sameAs') }
  it { is_expected.to have_editable_property(:citation, RDF::Vocab::DC.bibliographicCitation) }
  it { is_expected.to have_editable_property(:creator_role, RDF::Vocab::BF2.role) }
  it { is_expected.to have_editable_property(:contributor_role, 'http://example.com/donut/contributor/role') }
  it { is_expected.to have_editable_property(:genre, 'http://www.europeana.eu/schemas/edm/hasType') }
  it { is_expected.to have_editable_property(:physical_description, RDF::Vocab::Bibframe.extent) }
  it { is_expected.to have_editable_property(:provenance, RDF::Vocab::DC.provenance) }
  it { is_expected.to have_editable_property(:related_url_label, RDF::RDFS.label) }
  it { is_expected.to have_editable_property(:rights_holder, RDF::Vocab::DC.rightsHolder) }
  it { is_expected.to have_editable_property(:style_period, 'http://purl.org/vra/StylePeriod') }
  it { is_expected.to have_editable_property(:technique, 'http://purl.org/vra/Technique') }
  it { is_expected.to have_editable_property(:nul_creator, Vocab::Donut.has_creator) }
  it { is_expected.to have_editable_property(:nul_subject, Vocab::Donut.has_subject) }
  it { is_expected.to have_editable_property(:nul_contributor, Vocab::Donut.has_contributor) }
end
