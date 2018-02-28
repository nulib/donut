
RSpec.shared_examples 'a model with workflow metadata' do
  it do
    is_expected
      .to have_editable_property(:abstract)
      .with_predicate(RDF::Vocab::DC.abstract)
  end

  it do
    is_expected
      .to have_editable_property(:box_name)
      .with_predicate('http://opaquenamespace.org/ns/boxName')
  end

  it do
    is_expected
      .to have_editable_property(:box_number)
      .with_predicate('http://opaquenamespace.org/ns/boxNumber')
  end

  it do
    is_expected
      .to have_editable_property(:folder_name)
      .with_predicate('http://opaquenamespace.org/ns/folderName')
  end

  it do
    is_expected
      .to have_editable_property(:folder_number)
      .with_predicate('http://opaquenamespace.org/ns/folderNumber')
  end
end
