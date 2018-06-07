require 'rails_helper'

RSpec.describe ValidationController, type: :controller do
  describe 'POST #validate_new' do
    context 'with valid attributes' do
      it 'returns a success message' do
        post :validate_new, params: { image: FactoryBot.attributes_for(:image) }
        expect(response.status).to equal(200)
        expect(response.parsed_body).to eq('{"message":"Validation Success"}')
      end
    end

    context 'with invalid attributes' do
      it 'returns an error message' do
        post :validate_new, params: { image: FactoryBot.attributes_for(:image).except(:title) }
        expect(response.status).to equal(200)
        expect(response.parsed_body).to include('error')
      end
    end
  end

  describe 'POST #validate_edit' do
    let(:accession_number) { 'abc123' }
    let(:valid_attributes) do
      {
        title: ['the title'],
        accession_number: accession_number,
        creator: ['http://creator'],
        date_created: ['1927'],
        preservation_level: '1',
        status: 'Done',
        rights_statement: ['http://rightsstatements.org/vocab/NKC/1.0/']
      }
    end
    let(:image) { FactoryBot.create(:image, accession_number: accession_number) }

    context 'with valid attributes' do
      it 'returns a success message' do
        patch :validate_edit, params: { image: valid_attributes }
        expect(response.status).to equal(200)
        expect(response.parsed_body).to eq('{"message":"Validation Success"}')
      end
    end

    context 'with invalid attributes' do
      it 'returns an error message' do
        patch :validate_edit, params: { image: valid_attributes.except(:title) }
        expect(response.status).to equal(200)
        expect(response.parsed_body).to include('error')
      end
    end
  end
end
