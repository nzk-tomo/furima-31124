FactoryBot.define do
  factory :trade do
    association :user
    association :item
    token = 'tok_' + Faker::Lorem.characters(number: 28)
  end
end
