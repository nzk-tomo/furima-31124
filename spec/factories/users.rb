FactoryBot.define do
  factory :user do
    gimei = Gimei.name
    nickname {gimei.first.romaji}
    email {Faker::Internet.free_email}
    password = '1a' + Faker::Internet.password(min_length: 4)
    password {password}
    password_confirmation {password}
    first_name {gimei.first.kanji}
    last_name {gimei.last.kanji}
    first_name_kana {gimei.first.katakana}
    last_name_kana {gimei.last.katakana}
    birth {Faker::Date.birthday(min_age: 18, max_age: 65)}
  end
end