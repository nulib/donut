require 'rails_helper'

RSpec.describe 'records/edit_fields/_contributor_role.html.erb', type: :view do
  let(:image) { Image.new }
  let(:form) { Hyrax::ImageForm.new(image, nil, controller) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/contributor_role", f: f, key: 'contributor_role' %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end

  it 'has url for autocomplete service' do
    expect(rendered).to have_selector('input[data-autocomplete-url="/authorities/search/loc/relators"][data-autocomplete="contributor_role"]')
  end
end
