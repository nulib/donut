# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LicenseValidator do
  before do
    class TestWork < ActiveFedora::Base
      validates :license, license: true

      property :license, predicate: ::RDF::Vocab::DC.rights, multiple: true do |index|
        index.as :stored_searchable
      end
    end
  end
  after do
    Object.send(:remove_const, :TestWork)
  end

  it 'fails when an invalid license is found' do
    invalid_license_work = TestWork.create(license: ['notalicense'])

    expect(invalid_license_work).to be_invalid
  end

  it 'fails when an inactive license is found' do
    invalid_license_work = TestWork.create(license: ['http://creativecommons.org/licenses/by/3.0/us/'])

    expect(invalid_license_work).to be_invalid
  end

  it 'succeeds when valid license is found' do
    valid_license_work = TestWork.create(license: ['https://creativecommons.org/licenses/by-nc-sa/4.0/'])

    expect(valid_license_work).to be_valid
  end
end
