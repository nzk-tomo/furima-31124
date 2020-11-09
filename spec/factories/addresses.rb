FactoryBot.define do
  factory :address do
    association :trade
    a = Gimei.address
    postal_code = Faker::Number.leading_zero_number(digits: 3) + '-' + Faker::Number.leading_zero_number(digits: 4)
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    city { a.city.kanji }
    address { a.town.kanji }
    building = ''
    phone_number { Faker::Number.leading_zero_number(digits: 10) }
  end
end
