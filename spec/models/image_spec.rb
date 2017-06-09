# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:depositor) }
  it { is_expected.to respond_to(:creator) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:rights_statement) }
end
