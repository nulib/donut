FactoryGirl.define do
  factory :user, class: User do
    sequence(:email) { |_n| "email-#{srand}@test.com" }
  end
end
