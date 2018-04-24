# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusValidator do
  before do
    class TestWork < ActiveFedora::Base
      validates :status, status: true

      property :status, predicate: ::Vocab::Donut.status, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
  after do
    Object.send(:remove_const, :TestWork)
  end

  it 'fails when an invalid status is found' do
    invalid_status_work = TestWork.create(status: 'wrong')

    expect(invalid_status_work).to be_invalid
  end

  it 'succeeds when valid status is found' do
    valid_status_work = TestWork.create(status: 'In progress')

    expect(valid_status_work).to be_valid
  end
end
