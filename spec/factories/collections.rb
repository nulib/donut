FactoryBot.define do
  factory :collection do
    transient do
      user { FactoryBot.create(:user) }
    end

    title ['Test title']

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user)
    end
  end
end
