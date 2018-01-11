require 'hyrax/spec/matchers'

RSpec.shared_examples 'a model with admin metadata attributes' do
  it 'has project name' do
    expect(work)
      .to have_editable_property(:project_name)
      .with_predicate(::Vocab::Donut.project_name)
  end
end
