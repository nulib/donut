require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SolrDocument do
  subject(:solr_doc) { described_class.new(document_hash) }

  let(:date_created) { '2017-06-23' }
  let(:system_created) { '2017-06-23T12:34:56Z' }
  let(:date_modified) { '2017-06-23T13:34:56Z' }
  let(:document_hash) do
    {
      date_created_tesim: date_created,
      system_modified_dtsi: date_modified,
      system_create_dtsi: system_created,
      has_model_ssim: ['Image'],
      title_tesim: ['Test title'],
      alternate_title_tesim: ['Alternate Title 1'],
      abstract_tesim: ['Lemon drops donut gummi bears carrot cake dragée.'],
      accession_number_tesim: ['Lgf0825'],
      box_name_tesim: ['A good box name'],
      box_number_tesim: ['42'],
      call_number_tesim: ['W107.8:Am6'],
      caption_tesim: ['This is the caption seen on the image'],
      catalog_key_tesim: ['9943338434202441'],
      citation_tesim: ['Test'],
      folder_name_tesim: ['The folder name'],
      folder_number_tesim: ['99'],
      genre_tesim: ['Postmodern'],
      provenance: ['The example provenance'],
      physical_description_tesim: ['Wood 6cm x 7cm'],
      rights_holder_tesim: ['Northwestern University Libraries'],
      style_period_tesim: ['Renaissance'],
      technique_tesim: ['Test title'],
      resource_type_tesim: ['Image'],
      rights_statement_tesim: ['test'],
      member_of_collection_ids_ssim: ['1'],
      project_name_tesim: ['Project name'],
      project_description_tesim: ['Description'],
      proposer_tesim: ['Proposer'],
      project_manager_tesim: ['Project manager'],
      task_number_tesim: ['1'],
      preservation_level_tesim: ['1'],
      project_cycle_tesim: ['Project cycle 1'],
      status_tesim: ['Reviewed'],
      nul_creator_tesim: ['Willie Wildcat'],
      subject_tesim: ['Just Northwestern Things'],
      nul_contributor_tesim: ['ContribCat']
    }
  end

  describe '#member_of_collection_ids' do
    it 'returns the collection names' do
      expect(solr_doc.member_of_collection_ids).to eq ['1']
    end
  end

  describe '#rights_statement' do
    it 'returns the rights statement' do
      expect(solr_doc.rights_statement).to eq ['test']
    end
  end

  describe '#create_date' do
    it 'returns date_created_tesim' do
      expect(solr_doc.create_date.to_s).to eq '2017-06-23'
    end
  end

  describe '#date_created' do
    it 'returns date_created_tesim' do
      expect(solr_doc.date_created).to eq ['2017-06-23']
    end
  end
end
# rubocop:enable Metrics/BlockLength
