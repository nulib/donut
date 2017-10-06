# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImageForm do
  let(:image) { FactoryGirl.create(:image) }
  let(:ability) { Ability.new(nil) }
  let(:request) { nil }
  let(:form)    { described_class.new(image, ability, request) }

  describe '::terms' do
    subject { form.terms }

    it do
      is_expected.to include(:resource_type, :abstract, :accession_number, :call_number, :caption, :catalog_key, :citation, :contributor_role, :creator_role, :genre, :provenance, :physical_description, :related_url_label, :rights_holder, :style_period, :technique)
    end
  end

  describe '::required_fields' do
    subject { form.required_fields }

    it do
      is_expected.to contain_exactly(:title, :date_created, :accession_number, :rights_statement)
    end
  end

  describe '#primary_terms' do
    subject { form.primary_terms }

    it do
      is_expected.to include(:title, :date_created, :accession_number, :creator, :description)
    end
  end
end
