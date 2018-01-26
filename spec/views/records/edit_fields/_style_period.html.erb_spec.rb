require 'rails_helper'

RSpec.describe 'records/edit_fields/_style_period.html.erb', type: :view do
  let(:image) { Image.new }
  let(:form) { Hyrax::ImageForm.new(image, nil, controller) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "records/edit_fields/style_period", f: f, key: 'style_period' %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end

  it 'has url for autocomplete service' do
    expect(rendered).to have_selector('input[data-autocomplete-url="/authorities/search/getty/aat"][data-autocomplete="style_period"]')
  end
end
