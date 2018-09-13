# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImageForm do
  let(:image) { FactoryBot.create(:image) }
  let(:ability) { Ability.new(nil) }
  let(:request) { nil }
  let(:form)    { described_class.new(image, ability, request) }

  describe '::terms' do
    subject { form.terms }

    it 'contains fields that users should be allowed to edit' do
      is_expected.to include(
        :abstract,
        :accession_number,
        :box_name,
        :box_number,
        :call_number,
        :caption,
        :catalog_key,
        :folder_name,
        :folder_number,
        :genre,
        :notes,
        :nul_contributor,
        :nul_creator,
        :nul_use_statement,
        :physical_description_material,
        :physical_description_size,
        :preservation_level,
        :project_cycle,
        :project_description,
        :project_manager,
        :project_name,
        :proposer,
        :provenance,
        :related_material,
        :resource_type,
        :rights_holder,
        :scope_and_contents,
        :series,
        :status,
        :style_period,
        :subject_temporal,
        :table_of_contents,
        :task_number,
        :technique
      )
    end

    it 'does not contain fields that users should not be allowed to edit' do
      is_expected.not_to include(:ark)
    end
  end

  describe '::required_fields' do
    subject { form.required_fields }

    it do
      is_expected.to contain_exactly(:accession_number, :title, :date_created, :rights_statement, :preservation_level, :status)
    end
  end

  describe '#primary_terms' do
    subject { form.primary_terms }

    it do
      is_expected.to contain_exactly(:title,
                                     :date_created,
                                     :accession_number,
                                     :creator,
                                     :description,
                                     :rights_statement,
                                     :preservation_level,
                                     :status)
    end
  end
end
