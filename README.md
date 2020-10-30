## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| email              | string | null: false |
| password           | string | null: false |
| encrypted_password | string | null: false |
| nickname           | string | null: false |
| first_name         | string | null: false |
| last_name          | string | null: false |
| first_name_kana    | string | null: false |
| last_name_kana     | string | null: false |
| birth              | date   | null: false |

### Association

 - has_many :buyers
 - has_many :items 
 - has_many :comments

## items テーブル

| Column           | Type       | Options                        |
| ---------------- | ---------- | ------------------------------ |
| name             | string     | null: false                    |
| description      | text       | null: false                    |
| price            | integer    | null: false                    |
| category_id      | integer    | null: false                    |
| condition_id     | integer    | null: false                    |
| shipping_fee_id  | integer    | null: false                    |
| ship_from_id     | integer    | null: false                    |
| delivery_date_id | integer    | null: false                    |
| user             | references | null: false, foreign_key: true |

### Association

 - belongs_to :user
 - has_one :buyer
 - has_many :comments, dependent: :destroy

## buyers テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| user   | references | null: false, foreign_key: true |
| item   | references | null: false, foreign_key: true |

### Association

 - belongs_to :user
 - belongs_to :item
 - has_one :address

## addresses テーブル

| Column        | Type       | Options                        |
| --------------| ---------- | ------------------------------ |
| buyer         | references | null: false, foreign_key: true |
| postal_cord   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| address       | string     | null: false                    |
| building      | string     |                                |
| phone_number  | string     | null: false                    |

### Association

 - belongs_to :buyer

## comments テーブル

| Column  | Type       | Options                        |
| --------| ---------- | ------------------------------ |
| comment | text       | null: false                    |
| user    | references | null: false, foreign_key: true |
| item    | references | null: false, foreign_key: true |

### Association

 - belongs_to :user
 - belongs_to :item