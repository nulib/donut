require 'rails_helper'

RSpec.describe FileSet do
  let(:file_set) { described_class.create(label: 'file_x.tif') }

  describe 'with area of interest' do
    before do
      AreaOfInterest.create(file_id: 'file_x', x: 10, y: 50, width: 1024, height: 768, rotation: 270)
    end

    it 'is recorded' do
      expect(file_set.area_of_interest).to eq('10,50,1024,768,270')
    end
  end

  describe 'no area of interest' do
    it 'is nil' do
      expect(file_set.area_of_interest).to be_blank
    end
  end
end
