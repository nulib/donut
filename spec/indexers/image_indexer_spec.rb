# frozen_string_literal: true

require 'rails_helper'

describe ImageIndexer do
  describe '#generate_solr_document' do
    let(:solr_doc) { described_class.new(image).generate_solr_document }

    before do
      allow(image).to receive(:file_set_ids).and_return([file_set.id])
      allow(FileSet).to receive(:find).with(file_set.id).and_return(file_set)
      allow(IiifDerivativeService).to receive(:resolve).with(file.id).and_return(iiif_url)
    end

    context 'with an image' do
      let(:image) { FactoryBot.build(:image, date_created: ['1987~', 'uuuu']) }
      let(:file_set) { FactoryBot.create(:file_set).tap { |fs| fs.original_file = file } }
      let(:iiif_url) { 'http://thisistheiiifurl' }

      let(:file) do
        Hydra::PCDM::File.new.tap do |f|
          f.content = 'foo'
          f.original_name = 'picture.png'
          f.save!
        end
      end

      it 'indexes the human readable/display for date_created' do
        expect(solr_doc['date_created_display_tesim']).to match_array(['circa 1987', 'unknown'])
      end

      it 'indexes the iiif url for the filesets' do
        expect(solr_doc['file_set_iiif_urls_ssim']).to match_array(iiif_url)
      end
    end
  end
end
