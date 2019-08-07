require 'rails_helper'

RSpec.describe CommonIndexers::Image do
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

  describe '#generate' do
    it 'includes whether an image is at the top-level in a collection' do
      expect(described_class.new(parent_image).generate[:collection].first[:top_level]).to eq true
      expect(described_class.new(child_image).generate[:collection].first[:top_level]).to eq false
    end
  end
end
