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

    it 'contains fields that users should are allowed to edit' do
      is_expected.to include(:resource_type,
                             :abstract,
                             :accession_number,
                             :call_number,
                             :caption,
                             :catalog_key,
                             :citation,
                             :contributor_role,
                             :creator_role,
                             :genre,
                             :provenance,
                             :physical_description,
                             :rights_holder,
                             :style_period,
                             :technique,
                             :preservation_level,
                             :status,
                             :project_name,
                             :project_description,
                             :proposer,
                             :project_manager,
                             :task_number,
                             :project_cycle,
                             :nul_creator,
                             :nul_subject,
                             :nul_contributor)
    end

    it 'does not contain fields that users should not be allowed to edit' do
      is_expected.not_to include(:ark)
    end
  end

  describe '::required_fields' do
    subject { form.required_fields }

    it do
      is_expected.to contain_exactly(:title, :date_created, :rights_statement, :preservation_level, :status)
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
