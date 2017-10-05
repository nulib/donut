require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'hyrax/base/_attribute_rows.html.erb', type: :view do
  let(:url) { 'http://example.com' }
  let(:citation_text) { 'Blah blah blah' }
  let(:creator_role) { 'The Role' }
  let(:rights_statement_uri) { 'http://rightsstatements.org/vocab/InC/1.0/' }
  let(:ability) { double }
  let(:work) do
    stub_model(Image,
               related_url: [url],
               rights_statement: [rights_statement_uri],
               citation: [citation_text],
               creator_role: [creator_role])
  end
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:presenter) { Hyrax::ImagePresenter.new(solr_document, ability) }

  let(:page) do
    render 'hyrax/base/attribute_rows', presenter: presenter
  end

  it 'shows external link with icon for related url field' do
    expect(page).to have_selector '.glyphicon-new-window'
    expect(page).to have_link(url)
  end

  it 'shows rights statement with link to statement URL' do
    expect(page).to have_link(rights_statement_uri)
  end

  it 'shows NU attributes' do
    expect(page).to have_content(citation_text)
    expect(page).to have_content(creator_role)
  end
end
# rubocop:enable Metrics/BlockLength
