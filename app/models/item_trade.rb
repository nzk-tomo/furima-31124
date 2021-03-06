class ItemTrade
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id, :token

  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'はハイフンの入力願います' }
    validates :prefecture_id, exclusion: { in: ["1"], message: 'を選択してください' }
    validates :city
    validates :address
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'は半角数字・ハイフンなしで入力してください' }
    validates :token
    validates :user_id
    validates :item_id
  end

  def save
    trade = Trade.create(user_id: user_id, item_id: item_id)
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, address: address, building: building, phone_number: phone_number, trade_id: trade.id)
  end
end
