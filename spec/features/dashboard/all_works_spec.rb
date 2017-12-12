require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Batch Select on All Works Page', js: false do
  context 'logged in as admin' do
    let(:user) { FactoryBot.create(:admin) }
    let(:image) { FactoryBot.create(:image, user: user) }

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
      image.update_index
    end

    scenario do
      visit '/dashboard/works'
      check 'check_all'
      expect(page).to have_selector("input[type=submit][value='Edit Selected']")
      expect(page).to have_selector("input[type=submit][value='Delete Selected']")
      expect(page).to have_content('Add to Collection')
    end
  end
end
