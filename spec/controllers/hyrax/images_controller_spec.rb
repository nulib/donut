# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImagesController do
  it { is_expected.to be_kind_of(Hyrax::WorksControllerBehavior) }

  describe '#curation_concern_type' do
    subject { described_class.curation_concern_type }
    it { is_expected.to eq(::Image) }
  end
end
