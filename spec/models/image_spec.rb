# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  subject(:image) { FactoryBot.build(:image) }

  it_behaves_like 'a model with admin metadata'
  it_behaves_like 'a model with image metadata'
  it_behaves_like 'a model with hyrax basic metadata'
end
