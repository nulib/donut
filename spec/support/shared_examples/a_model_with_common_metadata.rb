RSpec.shared_examples 'a model with common metadata' do
  it { is_expected.to have_editable_property(:architect, RDF::Vocab::MARCRelators.arc) }
  it { is_expected.to have_editable_property(:artist, RDF::Vocab::MARCRelators.art) }
  it { is_expected.to have_editable_property(:author, RDF::Vocab::MARCRelators.aut) }
  it { is_expected.to have_editable_property(:cartographer, RDF::Vocab::MARCRelators.ctg) }
  it { is_expected.to have_editable_property(:compiler, RDF::Vocab::MARCRelators.com) }
  it { is_expected.to have_editable_property(:composer, RDF::Vocab::MARCRelators.cmp) }
  it { is_expected.to have_editable_property(:designer, RDF::Vocab::MARCRelators.dsr) }
  it { is_expected.to have_editable_property(:director, RDF::Vocab::MARCRelators.drt) }
  it { is_expected.to have_editable_property(:draftsman, RDF::Vocab::MARCRelators.drm) }
  it { is_expected.to have_editable_property(:editor, RDF::Vocab::MARCRelators.edt) }
  it { is_expected.to have_editable_property(:engraver, RDF::Vocab::MARCRelators.egr) }
  it { is_expected.to have_editable_property(:illustrator, RDF::Vocab::MARCRelators.ill) }
  it { is_expected.to have_editable_property(:librettist, RDF::Vocab::MARCRelators.lbt) }
  it { is_expected.to have_editable_property(:performer, RDF::Vocab::MARCRelators.prf) }
  it { is_expected.to have_editable_property(:photographer, RDF::Vocab::MARCRelators.pht) }
  it { is_expected.to have_editable_property(:presenter, RDF::Vocab::MARCRelators.pre) }
  it { is_expected.to have_editable_property(:printer, RDF::Vocab::MARCRelators.prt) }
  it { is_expected.to have_editable_property(:printmaker, RDF::Vocab::MARCRelators.prm) }
  it { is_expected.to have_editable_property(:producer, RDF::Vocab::MARCRelators.pro) }
  it { is_expected.to have_editable_property(:production_manager, RDF::Vocab::MARCRelators.pmn) }
  it { is_expected.to have_editable_property(:screenwriter, RDF::Vocab::MARCRelators.aus) }
  it { is_expected.to have_editable_property(:sculptor, RDF::Vocab::MARCRelators.scl) }
  it { is_expected.to have_editable_property(:sponsor, RDF::Vocab::MARCRelators.spn) }
end