require 'rails_helper'

RSpec.describe AdminSet do
  describe '#to_common_index' do
    it 'maps metadata to a hash for indexing' do
      expect(described_class.new.to_common_index).to be_kind_of(Hash)
    end
  end
end
