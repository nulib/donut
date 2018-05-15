require 'rails_helper'

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
      folder_name_tesim: ['The folder name'],
      folder_number_tesim: ['99'],
      genre_tesim: ['Postmodern'],
      provenance: ['The example provenance'],
      physical_description_size_tesim: ['Wood 6cm x 7cm'],
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
      nul_contributor_tesim: ['ContribCat'],
      photometric_interpretation_tesim: ['sample interpretation'],
      samples_per_pixel_tesim: ['1'],
      x_resolution_tesim: ['72'],
      y_resolution_tesim: ['73'],
      resolution_unit_tesim: ['inches'],
      date_time_tesim: ['2018-01-01'],
      bits_per_sample_tesim: ['1'],
      make_tesim: ['nec scanner'],
      strip_offsets_tesim: ['1'],
      rows_per_strip_tesim: ['1'],
      strip_byte_counts_tesim: ['1'],
      icc_profile_description_tesim: ['Adobe RGB (1998)'],
      donut_exif_version_tesim: ['10.00'],
      exif_all_data_tesim: ['all the data']
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

  describe '#photometric_interpretation' do
    it 'returns photometric_interpretation' do
      expect(solr_doc.photometric_interpretation).to eq ['sample interpretation']
    end
  end

  describe '#samples_per_pixel' do
    it 'returns samples_per_pixel' do
      expect(solr_doc.samples_per_pixel).to eq ['1']
    end
  end

  describe '#x_resolution' do
    it 'returns x_resolution' do
      expect(solr_doc.x_resolution).to eq ['72']
    end
  end

  describe '#y_resolution' do
    it 'returns y_resolution' do
      expect(solr_doc.y_resolution).to eq ['73']
    end
  end

  describe '#resolution_unit' do
    it 'returns resolution_unit' do
      expect(solr_doc.resolution_unit).to eq ['inches']
    end
  end

  describe '#date_time' do
    it 'returns date_time' do
      expect(solr_doc.date_time).to eq ['2018-01-01']
    end
  end

  describe '#bits_per_sample' do
    it 'returns bits_per_sample' do
      expect(solr_doc.bits_per_sample).to eq ['1']
    end
  end

  describe '#make' do
    it 'returns make' do
      expect(solr_doc.make).to eq ['nec scanner']
    end
  end

  describe '#strip_offsets' do
    it 'returns strip_offsets' do
      expect(solr_doc.strip_offsets).to eq ['1']
    end
  end

  describe '#rows_per_strip' do
    it 'returns rows_per_strip' do
      expect(solr_doc.rows_per_strip).to eq ['1']
    end
  end

  describe '#strip_byte_counts' do
    it 'returns strip_byte_counts' do
      expect(solr_doc.strip_byte_counts).to eq ['1']
    end
  end

  describe '#icc_profile_description' do
    it 'returns icc_profile_description' do
      expect(solr_doc.icc_profile_description).to eq ['Adobe RGB (1998)']
    end
  end

  describe '#donut_exif_version' do
    it 'returns donut_exif_version' do
      expect(solr_doc.donut_exif_version).to eq ['10.00']
    end
  end

  describe '#exif_all_data' do
    it 'returns exif_all_data' do
      expect(solr_doc.exif_all_data).to eq ['all the data']
    end
  end
end
