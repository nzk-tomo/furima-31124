require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#create' do
    before do
      @item = FactoryBot.build(:item)
    end

    describe '商品出品' do
      context '商品出品がうまくいくとき' do
        it "imageとname、descriptionとprice、
        category_idとcondition_id、shipping_fee_idとship_from_id、
        delivery_date_idおよびuser_idが存在すれば登録できる" do
          expect(@item).to be_valid
        end
      end
  
      context '商品出品がうまくいかないとき' do
        it "imageが空だと登録できない" do
          @item.image = nil
          @item.valid?
          expect(@item.errors.full_messages).to include("Image can't be blank")
        end
        it "nameが空だと登録できない" do
          @item.name = nil
          @item.valid?
          expect(@item.errors.full_messages).to include("Name can't be blank")
        end
        it "descriptionが空だと登録できない" do
          @item.description = nil
          @item.valid?
          expect(@item.errors.full_messages).to include("Description can't be blank")
        end
        it "priceが空だと登録できない" do
          @item.price = nil
          @item.valid?
          expect(@item.errors.full_messages).to include("Price can't be blank")
        end
        it "priceが全角数字だと登録できない" do
          @item.price = "３００"
          @item.valid?
          expect(@item.errors.full_messages).to include("Price Half-width number")
        end
        it "priceが文字列だと登録できない" do
          @item.price = "a"
          @item.valid?
          expect(@item.errors.full_messages).to include("Price Half-width number")
        end
        it "priceが300より小さいと登録できない" do
          @item.price = 299
          @item.valid?
          expect(@item.errors.full_messages).to include("Price Out of setting range")
        end
        it "priceが9999999より大きいと登録できない" do
          @item.price = 10000000
          @item.valid?
          expect(@item.errors.full_messages).to include("Price Out of setting range")
        end
        it "category_idが1だと登録できない" do
          @item.category_id = 1
          @item.valid?
          expect(@item.errors.full_messages).to include("Category Select")
        end
        it "condition_idが1だと登録できない" do
          @item.condition_id = 1
          @item.valid?
          expect(@item.errors.full_messages).to include("Condition Select")
        end
        it "shipping_fee_idが1だと登録できない" do
          @item.shipping_fee_id = 1
          @item.valid?
          expect(@item.errors.full_messages).to include("Shipping fee Select")
        end
        it "ship_from_idが1だと登録できない" do
          @item.ship_from_id = 1
          @item.valid?
          expect(@item.errors.full_messages).to include("Ship from Select")
        end
        it "delivery_date_idが1だと登録できない" do
          @item.delivery_date_id = 1
          @item.valid?
          expect(@item.errors.full_messages).to include("Delivery date Select")
        end
        it 'userが紐付いていないと保存できないこと' do
          @item.user = nil
          @item.valid?
          expect(@item.errors.full_messages).to include("User must exist")
        end
      end
    end
  end
end
