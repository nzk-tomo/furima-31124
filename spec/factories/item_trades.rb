FactoryBot.define do
  factory :item_trade do
    a = Gimei.address
    tkn = 'tok_' + Faker::Lorem.characters(number: 28)
    token {tkn}
    postal = Faker::Number.leading_zero_number(digits: 3) +'-'+ Faker::Number.leading_zero_number(digits: 4)
    postal_code {postal}
    prefecture_id {Faker::Number.between(from: 2, to: 48)}
    city {a.city.kanji}
    address {a.town.kanji}
    building = ""
    phone_number { Faker::Number.leading_zero_number(digits: 10) }

  end
end