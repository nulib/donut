require 'rails_helper'

RSpec.describe ImageVisibilityJob do
  let(:image) { FactoryBot.build(:image, visibility: 'restricted') }
  let(:file_set) { FactoryBot.create(:file_set, visibility: 'restricted') }

  before do
    image.ordered_members << file_set
    image.save!
  end

  it 'sets the visibility of an image and its FileSet members to open' do
    described_class.perform_now(image, 'open')
    expect(image.visibility).to eq 'open'
    expect(file_set.visibility).to eq 'open'
  end

  it 'changes `date_modified` of an image' do
    previous_date_modified = image.date_modified
    described_class.perform_now(image, 'authenticated')
    expect(image.date_modified).not_to eq previous_date_modified
  end
end
