# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Image', js: false do
  context 'a logged in user' do
    let(:depositor) { FactoryGirl.create(:user) }

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as depositor
    end

    scenario do
      visit '/dashboard'
      click_link 'Works'
      expect(page).to have_content 'Add new work'
      click_link 'Add new work'
      expect(page).to have_content 'Add New Image'
    end
  end
end
