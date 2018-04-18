# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceTypeValidator do
  before do
    class TestWork < ActiveFedora::Base
      include ::Hyrax::BasicMetadata
      validates :resource_type, resource_type: true
    end
  end
  after do
    Object.send(:remove_const, :TestWork)
  end

  context 'when resource_type is' do
    let(:image) { TestWork.create }

    it 'invalid :resource_type should return an error' do
      image.resource_type = ['invalid']
      image.save
      expect(image).to be_invalid
    end

    it 'valid :resource_type should should save successfully' do
      image.resource_type = ['Book']
      image.save
      expect(image).to be_valid
    end

    it 'nil :resource_type should save successfully' do
      image.resource_type = nil
      image.save
      expect(image).to be_valid
    end

    it 'part of a valid entry :resource_type should be invalid' do
      image.resource_type = ['Capstone']
      image.save
      expect(image).to be_invalid
    end
  end
end
