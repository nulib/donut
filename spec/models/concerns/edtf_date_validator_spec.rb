# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EdtfDateValidator do
  before do
    class TestWork < ActiveFedora::Base
      validates :date_created, edtf_date: true

      property :date_created, predicate: ::RDF::Vocab::DC.created, multiple: true do |index|
        index.as :stored_searchable
      end
    end
  end

  after do
    Object.send(:remove_const, :TestWork)
  end

  it 'fails with an invalid edtf date' do
    invalid_date_work = TestWork.create(date_created: ['notadate'])

    expect(invalid_date_work).to be_invalid
  end

  it 'returns an error message' do
    invalid_date_work = TestWork.create(date_created: ['notadate'])

    expect(invalid_date_work.errors[:date_created].first).to include 'notadate'
  end

  it 'succeeds with a blank date' do
    no_date = TestWork.create(date_created: [''])

    expect(no_date).to be_valid
  end

  it 'succeeds with a valid edtf season date' do
    work_season = TestWork.create(date_created: ['1975-22'])

    expect(work_season).to be_valid
  end

  it 'succeeds with a valid edtf interval date' do
    work_interval = TestWork.create(date_created: ['1981/1985'])

    expect(work_interval).to be_valid
  end

  it 'succeeds with a valid edtf set date' do
    work_set = TestWork.create(date_created: ['[1888, 1889, 1891]'])

    expect(work_set).to be_valid
  end

  it 'succeeds with a valid edtf unknown date' do
    work_unknown = TestWork.create(date_created: ['uuuu'])

    expect(work_unknown).to be_valid
  end

  it 'succeeds with a valid edtf century date' do
    work_century = TestWork.create(date_created: ['19xx'])

    expect(work_century).to be_valid
  end
end
