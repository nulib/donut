# frozen_string_literal: true

require 'rails_helper'

describe ImageIndexer do
  describe '#generate_solr_document' do
    let(:solr_doc) { described_class.new(image).generate_solr_document }

    context 'with an image' do
      let(:image) { FactoryBot.build(:image, date_created: ['1987~', 'uuuu']) }

      it 'indexes the human readable/display for date_created' do
        expect(solr_doc['date_created_display_tesim']).to match_array(['circa 1987', 'unknown'])
      end
    end
  end
end
