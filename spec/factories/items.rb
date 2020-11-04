FactoryBot.define do
  factory :item do
    name {Faker::Lorem.word}
    description {Faker::Lorem.sentence}
    price {Faker::Number.between(from: 300, to: 9999999)}
    category_id {Faker::Number.between(from: 2, to: 11)}
    condition_id {Faker::Number.between(from: 2, to: 7)}
    shipping_fee_id {Faker::Number.between(from: 2, to: 3)}
    ship_from_id {Faker::Number.between(from: 2, to: 48)}
    delivery_date_id {Faker::Number.between(from: 2, to: 4)}
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
