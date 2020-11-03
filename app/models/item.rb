class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  
  with_options presence: true do
    validates :name
    validates :description
    validates :price, numericality: {only_integer:true, greater_than: 299, less_than: 10000000}
    validates :category_id
    validates :condition_id
    validates :shipping_fee_id
    validates :ship_from_id
    validates :delivery_date_id
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_fee
  belongs_to :prefecture
  belongs_to :delivery_date
  
  with_options numericality: { other_than: 1 } do
    validates :category_id
    validates :condition_id
    validates :shipping_fee_id
    validates :ship_from_id
    validates :delivery_date_id
  end
end
