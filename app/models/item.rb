class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  
  with_options presence: true do
    validates :image
    validates :name
    validates :description
    validates :price, inclusion: { in: 300..9999999, message: "Out of setting range"},
     numericality: { with:/\A[0-9]+\z/,message: 'Half-width number'}
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
  
  with_options exclusion: { in:[1], message: "Select"} do
    validates :category_id
    validates :condition_id
    validates :shipping_fee_id
    validates :ship_from_id
    validates :delivery_date_id
  end
end
