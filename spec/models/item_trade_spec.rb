require 'rails_helper'

RSpec.describe ItemTrade, type: :model do
  describe '#create' do
    before do
      @item_trade = FactoryBot.build(:item_trade)
    end

    describe '商品購入' do
      context '商品購入がうまくいくとき' do
        it 'すべての値が正しく入力されていれば保存できること' do
          expect(@item_trade).to be_valid
        end
      end

      context '商品購入がうまくいかないとき' do
        it 'tokenが空では保存ができないこと' do
          @item_trade.token = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("Token can't be blank")
        end
        it 'postal_codeが空では保存ができないこと' do
          @item_trade.postal_code = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("Postal code can't be blank")
        end
        it 'postal_codeの入力にハイフンがないとき保存ができないこと' do
          @item_trade.postal_code = 1_234_567
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Postal code はハイフンの入力願います')
        end
        it 'postal_codeが字数以下のとき保存ができないこと' do
          @item_trade.postal_code = '123-456'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Postal code はハイフンの入力願います')
        end
        it 'postal_codeが字数以上のとき保存ができないこと' do
          @item_trade.postal_code = '123-45678'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Postal code はハイフンの入力願います')
        end
        it 'postal_codeに正規表現外の文字列が入力されたとき保存ができないこと' do
          @item_trade.postal_code = '１２３−４５６７'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Postal code はハイフンの入力願います')
        end
        it 'prefecture_idが1であるとき保存ができないこと' do
          @item_trade.prefecture_id = 1
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Prefecture を選択してください')
        end
        it 'cityが空では保存ができないこと' do
          @item_trade.city = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("City can't be blank")
        end
        it 'addressが空では保存ができないこと' do
          @item_trade.address = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("Address can't be blank")
        end
        it 'phone_numberが空では保存ができないこと' do
          @item_trade.phone_number = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("Phone number can't be blank")
        end
        it 'phone_numberの入力にハイフンがあるとき保存ができないこと' do
          @item_trade.phone_number = '090-1234-5678'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Phone number は半角数字・ハイフンなしで入力してください')
        end
        it 'phone_numberの入力が字数以下であるとき保存ができないこと' do
          @item_trade.phone_number = '000'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Phone number は半角数字・ハイフンなしで入力してください')
        end
        it 'phone_numberの入力が字数以上であるとき保存ができないこと' do
          @item_trade.phone_number = '090123456789'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Phone number は半角数字・ハイフンなしで入力してください')
        end
        it 'phone_numberの入力に正規表現外の文字列が入力されたとき保存ができないこと' do
          @item_trade.phone_number = '０９０１２３４５６７８'
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include('Phone number は半角数字・ハイフンなしで入力してください')
        end
        it 'user_idが空白だと保存できないこと' do
          @item_trade.user_id = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("User can't be blank")
        end
        it 'item_idが空白だと保存できないこと' do
          @item_trade.item_id = nil
          @item_trade.valid?
          expect(@item_trade.errors.full_messages).to include("Item can't be blank")
        end
      end
    end
  end
end
