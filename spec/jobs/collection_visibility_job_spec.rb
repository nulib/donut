require 'rails_helper'

RSpec.describe CollectionVisibilityJob do
  let(:open_image) { FactoryBot.create(:image) }
  let(:restricted_image) { FactoryBot.create(:image, visibility: 'restricted') }
  let(:authenticated_image) { FactoryBot.create(:image, visibility: 'authenticated') }
  let(:collection) { FactoryBot.build(:collection) }

  before do
    collection.add_member_objects [open_image.id, restricted_image.id, authenticated_image.id]
    collection.save!
  end

  it 'enqueues ImageVisibilityJob jobs for restricted and authenticated images' do
    ActiveJob::Base.queue_adapter = :test
    expect { described_class.perform_now(collection.id, 'open') }.to enqueue_job(ImageVisibilityJob).twice
  end
end
