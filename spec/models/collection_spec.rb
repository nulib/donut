require 'rails_helper'

RSpec.describe Collection do
  let(:collection_type) { Hyrax::CollectionType.new(title: 'something') }

  before do
    allow(Hyrax::CollectionType).to receive(:find).with('1').and_return(collection_type)
  end

  describe '#to_common_index' do
    it 'maps metadata to a hash for indexing' do
      expect(described_class.new(collection_type_gid: 'gid://nextgen/hyrax-collectiontype/1').to_common_index).to be_kind_of(Hash)
    end
  end
end
