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
  it_behaves_like 'a model with hyrax basic metadata', except: [:contributor, :creator, :keyword, :language, :license]

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

  describe '#to_common_index' do
    it 'maps metadata to a hash for indexing' do
      image_with_id = FactoryBot.build(:image, id: 'abc124')
      expect(image_with_id.to_common_index).to be_kind_of(Hash)
    end
  end

  describe '#top_level_in_collection?' do
    let(:parent_image) { FactoryBot.build(:image) }
    let(:child_image) { FactoryBot.build(:image) }
    let(:collection) { FactoryBot.build(:collection) }

    before do
      parent_image.ordered_members << child_image
      parent_image.save!

      [parent_image, child_image].each do |asset|
        asset.member_of_collections << collection
        asset.save!
      end
    end

    it 'knows when an image is top-level in a collection (no parent image)' do
      expect(parent_image.top_level_in_collection?(collection)).to be true
      expect(child_image.top_level_in_collection?(collection)).to be false
    end
  end
end
