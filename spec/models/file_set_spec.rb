require 'rails_helper'

RSpec.describe FileSet do
  subject(:file_set) { FactoryBot.build(:file_set) }
  it 'has tests' do
    skip 'Add your tests here'
  end

  describe 'technical metadata member' do
    subject(:techMD) { FactoryBot.build(:technical_metadata) }

    it 'returns nil when a file set does not have a' do
      expect(file_set.technical_metadata).to be_nil
    end

    it 'returns the technical metadata when a file set has one' do
      techMD.file_set_id = file_set.id
      techMD.save
      expect(file_set.technical_metadata.class).to be(TechnicalMetadata)
    end
  end
end
