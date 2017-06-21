FactoryGirl.define do
  factory :image do
    title ['Test title']
    rights_statement ['http://rightsstatements.org/vocab/NKC/1.0/']
    description ['Test description']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC

    transient do
      user { FactoryGirl.create(:user) }
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end
  end
end
