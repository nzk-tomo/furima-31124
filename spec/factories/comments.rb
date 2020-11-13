FactoryBot.define do
  factory :comment do
    association :user
    association :item
    comment { Faker::Lorem.sentence }
  end
end
