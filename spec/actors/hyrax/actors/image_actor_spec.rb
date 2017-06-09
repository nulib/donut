# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::Actors::ImageActor do
  it 'is a BaseActor' do
    expect(described_class < ::Hyrax::Actors::BaseActor).to be true
  end
end
