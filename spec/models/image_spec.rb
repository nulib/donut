# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Image do
  # Basic Metadata
  it { is_expected.to respond_to(:based_near) }
  it { is_expected.to respond_to(:contributor) }
  it { is_expected.to respond_to(:creator) }
  it { is_expected.to respond_to(:depositor) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:keyword) }
  it { is_expected.to respond_to(:language) }
  it { is_expected.to respond_to(:license) }
  it { is_expected.to respond_to(:publisher) }
  it { is_expected.to respond_to(:related_url) }
  it { is_expected.to respond_to(:rights_statement) }
  it { is_expected.to respond_to(:title) }
  # NU Specific
  it { is_expected.to respond_to(:accession_number) }
  it { is_expected.to respond_to(:abstract) }
  it { is_expected.to respond_to(:alternate_title) }
  it { is_expected.to respond_to(:ark) }
  it { is_expected.to respond_to(:call_number) }
  it { is_expected.to respond_to(:caption) }
  it { is_expected.to respond_to(:catalog_key) }
  it { is_expected.to respond_to(:citation) }
  it { is_expected.to respond_to(:creator_role) }
  it { is_expected.to respond_to(:contributor_role) }
  it { is_expected.to respond_to(:genre) }
  it { is_expected.to respond_to(:provenance) }
  it { is_expected.to respond_to(:physical_description) }
  it { is_expected.to respond_to(:related_url_label) }
  it { is_expected.to respond_to(:rights_holder) }
  it { is_expected.to respond_to(:style_period) }
  it { is_expected.to respond_to(:technique) }
  # Administrative metadata
  it { is_expected.to respond_to(:project_name) }
  it { is_expected.to respond_to(:project_description) }
  it { is_expected.to respond_to(:proposer) }
  it { is_expected.to respond_to(:project_manager) }
  it { is_expected.to respond_to(:task_number) }
  it { is_expected.to respond_to(:preservation_level) }
  it { is_expected.to respond_to(:project_cycle) }
  it { is_expected.to respond_to(:status) }
end
# rubocop:enable Metrics/BlockLength
