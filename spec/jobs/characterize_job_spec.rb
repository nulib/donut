require 'rails_helper'

RSpec.describe CharacterizeJob do
  let(:file_set_id) { 'abc12345' }
  let(:filename)    { Rails.root.join('tmp', 'uploads', 'ab', 'c1', '23', '45', 'abc12345', 'picture.png').to_s }
  let(:file_set) do
    FileSet.new(id: file_set_id).tap do |fs|
      allow(fs).to receive(:original_file).and_return(file)
      allow(fs).to receive(:update_index)
      allow(fs).to receive(:mime_type).and_return('image/png')
    end
  end
  let(:file) do
    Hydra::PCDM::File.new.tap do |f|
      f.content = 'foo'
      f.original_name = 'picture.png'
      f.save!
      allow(f).to receive(:save!)
    end
  end

  before do
    allow(FileSet).to receive(:find).with(file_set_id).and_return(file_set)
    allow(Hydra::Works::CharacterizationService).to receive(:run).with(file, filename)
    allow(Donut::CharacterizationService).to receive(:run).with(file, filename)
    allow(CreatePyramidTiffJob).to receive(:perform_now).with(file_set)
  end

  context 'with valid filepath param' do
    let(:filename) { "#{fixture_path}/images/world.png" }

    it 'skips Hyrax::WorkingDirectory' do
      expect(Hyrax::WorkingDirectory).not_to receive(:find_or_retrieve)
      expect(Hydra::Works::CharacterizationService).to receive(:run).with(file, filename)
      expect(Donut::CharacterizationService).to receive(:run).with(file, filename)
      described_class.perform_now(file_set, file.id, filename)
    end
  end

  context 'when the characterization proxy content is present' do
    # rubocop:disable RSpec/ExampleLength
    it 'runs Hydra::Works::CharacterizationService and creates a CreateDerivativesJob' do
      expect(Hydra::Works::CharacterizationService).to receive(:run).with(file, filename)
      expect(Donut::CharacterizationService).to receive(:run).with(file, filename)
      expect(file).to receive(:save!)
      expect(file_set).to receive(:update_index)
      expect(CreatePyramidTiffJob).to receive(:perform_now).with(file_set)
      described_class.perform_now(file_set, file.id)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when the characterization proxy content is absent' do
    before { allow(file_set).to receive(:characterization_proxy?).and_return(false) }
    it 'raises an error' do
      expect { described_class.perform_now(file_set, file.id) }.to raise_error(StandardError, /original_file was not found/)
    end
  end

  context "when the file set's work is in a collection" do
    let(:work)       { build(:image) }
    let(:collection) { build(:collection) }

    before do
      allow(file_set).to receive(:parent).and_return(work)
      allow(work).to receive(:in_collections).and_return([collection])
    end
    it 'reindexes the collection' do
      expect(collection).to receive(:update_index)
      described_class.perform_now(file_set, file.id)
    end
  end
end
