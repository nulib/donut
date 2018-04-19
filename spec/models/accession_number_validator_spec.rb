# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessionNumberValidator do
  before do
    class TestWork < ActiveFedora::Base
      validates :accession_number, presence: { message: 'Accession number is required.' }, accession_number: true, on: :create

      property :accession_number, predicate: ::RDF::URI('http://id.loc.gov/vocabulary/subjectSchemes/local'), multiple: false do |index|
        index.as :stored_searchable
      end
    end

    TestWork.create(accession_number: 'test-1234')
    allow(Donut::DuplicateAccessionVerificationService).to receive(:duplicate?).with(/1234/).and_return(true)
    allow(Donut::DuplicateAccessionVerificationService).to receive(:duplicate?).with(/unique-accession/).and_return(false)
  end
  after do
    Object.send(:remove_const, :TestWork)
  end

  it 'fails when a duplicate accession_number is found' do
    duplicate_accession_work = TestWork.create(accession_number: 'test-1234')

    expect(duplicate_accession_work).to be_invalid
  end

  it 'returns an error message' do
    duplicate_accession_work = TestWork.create(accession_number: 'test-1234')

    expect(duplicate_accession_work.errors[:accession_number]).to eq ['Accession number must be unique']
  end

  it 'succeeds when a duplicate accession_number is not found' do
    duplicate_accession_work = TestWork.create(accession_number: 'unique-accession')

    expect(duplicate_accession_work).to be_valid
  end
end
