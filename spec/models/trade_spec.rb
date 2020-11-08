require 'rails_helper'

RSpec.describe ItemTrade, type: :model do
  describe '#create' do
    before do
      @item_trade = FactoryBot.build(:item_trade)
    end
  

    describe '商品購入' do
      context '商品購入がうまくいくとき' do
        it "priceがあれば保存ができること" do
          expect(@order).to be_valid
        end
      end
    
      context '商品出品がうまくいかないとき' do
        it "tokenが空では保存ができないこと" do
          @order.price = nil
          @order.valid?
          expect(@order.errors.full_messages).to include("Price can't be blank")
        end
        
      end
    end
  end
end
