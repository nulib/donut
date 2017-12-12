FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |_n| "email-#{srand}@test.com" }
    factory :admin do
      roles { [Role.where(name: 'admin').first_or_create] }
    end
  end
end
