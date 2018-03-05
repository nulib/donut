RSpec.shared_examples 'a model with admin metadata' do
  it do
    is_expected
      .to have_editable_property(:project_name)
      .with_predicate('http://www.library.northwestern.edu/terms#project_name')
  end

  it do
    is_expected
      .to have_editable_property(:project_cycle)
      .with_predicate('http://www.library.northwestern.edu/terms#project_cycle')
  end

  it do
    is_expected
      .to have_editable_property(:project_description)
      .with_predicate('http://www.library.northwestern.edu/terms#project_description')
  end

  it do
    is_expected
      .to have_editable_property(:project_manager)
      .with_predicate('http://www.library.northwestern.edu/terms#project_manager')
  end

  it do
    is_expected
      .to have_editable_property(:proposer)
      .with_predicate('http://www.library.northwestern.edu/terms#proposer')
  end

  it do
    is_expected
      .to have_editable_property(:task_number)
      .with_predicate('http://www.library.northwestern.edu/terms#task_number')
  end

  it do
    is_expected
      .to have_editable_property(:preservation_level)
      .with_predicate('http://www.library.northwestern.edu/terms#preservation_level')
      .as_single_valued
  end

  it do
    is_expected
      .to have_editable_property(:status)
      .with_predicate('http://www.library.northwestern.edu/terms#status')
  end
end
