# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImageForm do
  let(:work) { Image.new }
  let(:ability) { Ability.new(nil) }
  let(:request) { nil }
  let(:form)    { described_class.new(work, ability, request) }

  describe '::terms' do
    subject { form.terms }

    it do
      is_expected.to include(:title, :creator, :keyword, :license)
    end
  end
end
