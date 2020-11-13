require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.create(:comment)
  end

  describe 'コメント機能' do
    context 'コメントがうまくいくとき' do
      it 'すべての値が入力されていれば保存できること' do
        expect(@comment).to be_valid
      end
    end
    context '商品購入がうまくいかないとき' do
      it 'commentが空では保存ができないこと' do
        @comment.comment = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Comment can't be blank")
      end
      it 'userが紐付いていないと保存できないこと' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("User must exist")
      end
      it 'itemが紐付いていないと保存できないこと' do
        @comment.item = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Item must exist")
      end
    end
  end
end