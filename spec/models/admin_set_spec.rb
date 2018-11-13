require 'rails_helper'

RSpec.describe AdminSet do
  describe '#to_common_index' do
    it 'maps metadata to a hash for indexing' do
      expect(described_class.new(create_date: Hyrax::TimeService.time_in_utc, modified_date: Hyrax::TimeService.time_in_utc).to_common_index).to be_kind_of(Hash)
    end
  end
end
