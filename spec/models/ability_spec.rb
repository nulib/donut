require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(current_user) }

  let(:current_user) { FactoryBot.create(:user) }
  let(:manager_role) { instance_double('Role', name: 'rdc_managers') }

  describe 'a regular user' do
    it do
      is_expected.not_to be_able_to :show, Batch
    end
  end

  describe 'an admin user' do
    before { allow(current_user).to receive(:groups).and_return(['admin']) }
    it do
      is_expected.to be_able_to :show, Batch
    end
  end

  describe "a user with 'rdc_managers' role" do
    before { allow(current_user).to receive(:roles).and_return([manager_role]) }
    it do
      is_expected.to be_able_to :show, Batch
    end
  end
end
