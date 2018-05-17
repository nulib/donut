require 'rails_helper'

RSpec.describe Donut::ValidationService do
  let(:accession_number) { SecureRandom.uuid }
  let(:contributor) { [RDF::URI('http://id.worldcat.org/fast/1213442')] }
  let(:creator) { [RDF::URI('http://id.worldcat.org/fast/1213442')] }
  let(:klass) { Image }
  let(:common_attributes) do
    {
      accession_number: accession_number,
      title: ['Title'],
      contributor: contributor,
      creator: creator,
      date_created: ['2018'],
      admin_set_id: ['admin_set/default'],
      preservation_level: '2',
      status: Image::DEFAULT_STATUS,
      rights_statement: ['http://rightsstatements.org/vocab/InC-OW-EU/1.0/']
    }
  end

  context 'valid item' do
    let(:attributes) { common_attributes }

    it 'is valid' do
      expect(described_class).to be_valid(klass: klass, attributes: attributes)
    end

    it 'has no errors' do
      expect(described_class.errors(klass: klass, attributes: attributes)).to be_empty
    end
  end

  context 'item with missing attribute' do
    let(:attributes) { common_attributes.reject { |k, _v| k == :title } }

    it 'is not valid' do
      expect(described_class).not_to be_valid(klass: klass, attributes: attributes)
    end

    it 'has an error' do
      described_class.errors(klass: klass, attributes: attributes).tap do |errors|
        expect(errors.count).to eq(1)
        expect(errors.messages[:title]).to eq(['Your work must have a title.'])
      end
    end
  end

  context 'item with invalid attribute value' do
    let(:attributes) { common_attributes.merge(date_created: ['5/17/2018']) }

    it 'is valid' do
      expect(described_class).not_to be_valid(klass: klass, attributes: attributes)
    end

    it 'has an error' do
      described_class.errors(klass: klass, attributes: attributes).tap do |errors|
        expect(errors.count).to eq(1)
        expect(errors.messages[:date_created]).to eq(['Invalid EDTF date: 5/17/2018'])
      end
    end
  end
end
