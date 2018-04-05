# rubocop:disable Metrics/BlockLength

RSpec.shared_examples 'a model with technical metadata' do
  it { is_expected.to have_editable_property(:image_width, ::RDF::Vocab::EBUCore.width) }
  it { is_expected.to have_editable_property(:image_height, ::RDF::Vocab::EBUCore.width) }
end
# rubocop:enable Metrics/BlockLength
