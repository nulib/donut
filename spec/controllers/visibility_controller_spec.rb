require 'rails_helper'

RSpec.describe VisibilityController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:collection) { FactoryBot.create(:collection, user: admin) }

  describe 'POST #make_public' do
    context 'as a user that can edit the collection' do
      before do
        sign_in admin
      end

      it 'returns a success message' do
        post :change, params: { id: collection.id, visibility: 'open' }
        expect(response.status).to equal(302)
        expect(flash[:notice]).to include('Job submitted.')
      end
    end

    context 'as a user that cannot edit the collection' do
      before do
        sign_in user
      end

      it 'returns an unauthorized message' do
        post :change, params: { id: collection.id, visibility: 'open' }
        expect(response.status).to equal(401)
      end
    end
  end
end
