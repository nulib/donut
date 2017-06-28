require 'rails_helper'

RSpec.describe 'hyrax/base/_representative_media.html.erb' do
  let(:solr_doc) { instance_double('SolrDocument', representative_id: file_set.id, hydra_model: Image) }
  let(:pres) { Hyrax::WorkShowPresenter.new(solr_doc, nil) }
  let(:file_set) { FileSet.create! { |fs| fs.apply_depositor_metadata('atz') } }
  let(:file_presenter) { instance_double('FileSetPresenter', id: file_set.id, image?: true) }

  before do
    allow(pres).to receive_messages(representative_presenter: file_presenter)
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        File.open(fixture_path + '/images/world.png'),
                                        :original_file)
    render 'hyrax/base/representative_media', presenter: pres
  end

  it 'has a universal viewer' do
    expect(rendered).to have_selector 'div.viewer'
  end
end
