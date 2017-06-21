require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  subject(:admin) { described_class.new(current_user) }

  describe 'as an admin' do
    let(:admin_user) { FactoryGirl.create(:admin) }
    let(:current_user) { admin_user }
    let(:image) { FactoryGirl.create(:image, user: current_user) }

    # rubocop:disable RSpec/ExampleLength
    it {
      is_expected.to be_able_to(:create, Image.new)
      is_expected.to be_able_to(:create, FileSet.new)
      is_expected.to be_able_to(:read, image)
      is_expected.to be_able_to(:edit, image)
      is_expected.to be_able_to(:update, image)
      is_expected.to be_able_to(:destroy, image)
    }
    # rubocop:enable RSpec/ExampleLength

    it 'can create works' do
      expect(admin.can_create_any_work?).to be true
    end
  end
end
