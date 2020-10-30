## users テーブル

| Column          | Type    | Options     |
| --------------- | ------- | ----------- |
| email           | string  | null: false |
| password        | string  | null: false |
| nickname        | string  | null: false |
| first_name      | string  | null: false |
| last_name       | string  | null: false |
| first_name_kana | string  | null: false |
| last_name_kana  | string  | null: false |
| birth_y         | integer | null: false |
| birth_m         | integer | null: false |
| birth_d         | integer | null: false |

### Association

 - has_many :items
 - has_many :deliveries
 - has_many :buyers
 - has_many :comments 

## items テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| item_name      | string     | null: false                    |
| item_desc      | text       | null: false                    |
| item_image     | string     | null: false                    |
| item_category  | string     | null: false                    |
| item_condition | string     | null: false                    |
| item_price     | integer    | null: false                    |
| user_id        | references | null: false, foreign_key: true |

### Association

 - belongs_to :user
 - has_one :delivery
 - has_one :buyer
 - has_many :comments, dependent: :destroy

## deliveries テーブル

| Column            | Type       | Options                        |
| ----------------- | ---------- | ------------------------------ |
| item_id           | references | null: false, foreign_key: true |
| item_shipping_fee | integer    | null: false                    |
| item_ship_from    | string     | null: false                    |
| delivery_date     | integer    | null: false                    |

### Association

 - belongs_to :item

## buyers テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| buyer_user_id | references | null: false, foreign_key: true |
| buy_item_id   | references | null: false, foreign_key: true |
| card_number   | string     | ( by @pay.jp )                 |
| card_exp_m    | integer    | ( by @pay.jp )                 |
| card_exp_y    | integer    | ( by @pay.jp )                 |
| card_cvc      | integer    | ( by @pay.jp )                 |

### Association

 - belongs_to :user
 - belongs_to :item
 - has_one :buyer_address

## buyer_addresses テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| buyer_id     | references | null: false, foreign_key: true |
| postal_cord  | integer    | null: false                    |
| prefecture   | string     | null: false                    |
| city         | string     | null: false                    |
| address      | string     | null: false                    |
| building     | string     |                                |
| phone_number | integer    | null: false                    |

### Association

 - belongs_to :buyer

 ## comments テーブル
| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| comment      | text       | null: false                    |
| user_id      | references | null: false, foreign_key: true |
| item_id      | references | null: false, foreign_key: true |

### Association

 - belongs_to :user
 - belongs_to :item