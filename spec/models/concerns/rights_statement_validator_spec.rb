# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RightsStatementValidator do
  before do
    class TestWork < ActiveFedora::Base
      validates :rights_statement, rights_statement: true

      property :rights_statement, predicate: ::RDF::Vocab::EDM.rights, multiple: true do |index|
        index.as :stored_searchable
      end
    end
  end
  after do
    Object.send(:remove_const, :TestWork)
  end

  it 'fails when an invalid rights statment is found' do
    invalid_work = TestWork.create(rights_statement: ['notarightsstatement'])

    expect(invalid_work).to be_invalid
  end

  it 'succeeds when valid rights statement is found' do
    valid_work = TestWork.create(rights_statement: ['http://rightsstatements.org/vocab/NoC-OKLR/1.0/'])

    expect(valid_work).to be_valid
  end
end
