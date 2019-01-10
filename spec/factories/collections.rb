FactoryBot.define do
  factory :collection do
    transient do
      user { FactoryBot.create(:user) }
    end

    id { 'test-collection-id' }
    title { ['Test title'] }
    collection_type_gid { 'gid://nextgen/hyrax-collectiontype/1' }

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user)
    end
  end
end
