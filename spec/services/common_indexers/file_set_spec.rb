require 'rails_helper'

RSpec.describe CommonIndexers::FileSet do
  let(:file) { 'world.png' }
  let(:file_path) { "#{fixture_path}/images/#{file}" }
  let(:image) { FactoryBot.build(:image).tap(&:save) }
  let(:file_set) { FactoryBot.build(:file_set).tap(&:save) }
  let(:collection) { FactoryBot.build(:collection).tap(&:save) }
  let(:doc) { described_class.new(file_set).generate }

  before do
    file_set.label = file
    file_set.title = [file]
    Hydra::Works::AddFileToFileSet.call(file_set, File.open(file_path, 'rb'), :original_file)

    image.ordered_members << file_set
    image.member_of_collections << collection
    image.save!
  end

  describe '#generate' do
    it 'includes all expected fields' do
      expect(doc[:digest]).to match(/^urn:sha1:[0-9a-f]{40}$/)
      expect(doc[:id]).to match(/^[0-9a-f-]{36}$/)
      expect(doc[:label]).to eq(file)
      expect(doc[:mime_type]).to eq('image/png')
      expect(doc[:model]).to eq(application: 'Nextgen', name: 'FileSet')
      expect(doc[:simple_title]).to eq([file])
      expect(doc[:visibility]).to eq('restricted')
    end
  end
end
