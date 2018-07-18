require 'rails_helper'

RSpec.describe 'images/edit_fields/_language.html.erb', type: :view do
  let(:image) { Image.new }
  let(:form) { Hyrax::ImageForm.new(image, nil, controller) }
  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "images/edit_fields/language", f: f, key: 'language' %>
      <% end %>
    )
  end

  before do
    assign(:form, form)
    render inline: form_template
  end

  it 'has url for autocomplete service' do
    expect(rendered).to have_selector('input[data-autocomplete-url="/authorities/search/loc/languages"][data-autocomplete="language"]')
  end
end
