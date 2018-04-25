# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreservationLevelValidator do
  before do
    class TestWork < ActiveFedora::Base
      validates :preservation_level, preservation_level: true

      property :preservation_level, predicate: ::Vocab::Donut.preservation_level, multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
  after do
    Object.send(:remove_const, :TestWork)
  end

  context 'when preservation_level is' do
    let(:image) { TestWork.create }

    it 'invalid :preservation_level should return an error' do
      image.preservation_level = 99
      image.save
      expect(image).to be_invalid
    end

    it 'valid :preservation_level should should save successfully' do
      image.preservation_level = '1'
      image.save
      expect(image).to be_valid
    end

    it 'nil :preservation_level should not save successfully' do
      image.preservation_level = nil
      image.save
      expect(image).to be_invalid
    end
  end
end
