# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  subject(:image) { FactoryBot.build(:image) }

  it_behaves_like 'a model with admin metadata'
  it_behaves_like 'a model with workflow metadata'
  it_behaves_like 'a model with image metadata'
  it_behaves_like 'a model with common metadata'
  it_behaves_like 'a model with nul core metadata'
  it_behaves_like 'a model with hyrax basic metadata', except: [:contributor, :creator, :keyword, :language]

  it 'defaults status to Image.DEFAULT_STATUS' do
    attributes = FactoryBot.attributes_for(:image).except(:status)
    image_without_status = FactoryBot.build(:image, attributes)
    expect(image_without_status.status).to eq(Image::DEFAULT_STATUS)
  end

  it 'defaults preservation_level to Image.DEFAULT_PRESERVATION_LEVEL' do
    attributes = FactoryBot.attributes_for(:image).except(:preservation_level)
    image_without_preservation_level = FactoryBot.build(:image, attributes)
    expect(image_without_preservation_level.preservation_level).to eq(Image::DEFAULT_PRESERVATION_LEVEL)
  end
end
