require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    describe 'ユーザー新規登録' do
      context '新規登録がうまくいくとき' do
        it "nicknameとemail、passwordとpassword_confirmation、
        first_nameとlast_name、first_name_kanaとlast_name_kana
        およびbirthが存在すれば登録できる" do
          expect(@user).to be_valid
        end
        it "passwordが6文字以上の英数字混みであれば登録できる" do
          expect(@user).to be_valid
        end
      end
  
      context '新規登録がうまくいかないとき' do
        it "nicknameが空だと登録できない" do
          @user.nickname = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Nickname can't be blank")
        end
        it "emailが空では登録できない" do
          @user.email = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Email can't be blank")
        end
        it "emailに@が含まれていないため登録できない" do
          n = @user.email.index("@")
          @user.email.slice!(n)
          @user.valid?
          expect(@user.errors.full_messages).to include("Email is invalid")
        end
        it "emailが重複している場合登録できない" do
          @user.save
          another_user = FactoryBot.build(:user, email: @user.email)
          another_user.valid?
          expect(another_user.errors.full_messages).to include("Email has already been taken")
        end
        it "passwordが空では登録できない" do
          @user.password = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Password can't be blank")
        end
        it "passwordが英数字混合でなければ登録できない" do
          @user.password = "000000"
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it "passwordが5文字以下であれば登録できない" do
          @user.password = "aaaa5"
          @user.valid?
          expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
        end
        it "passwordが存在してもpassword_confirmationが空では登録できない" do
          @user.password_confirmation = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it "first_nameが空では登録できない" do
          @user.first_name = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("First name can't be blank")
        end
        it "last_nameが空では登録できない" do
          @user.last_name = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name can't be blank")
        end
        it "first_name_kanaが空では登録できない" do
          @user.first_name_kana = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("First name kana can't be blank")
        end
        it "last_name_kanaが空では登録できない" do
          @user.last_name_kana = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name kana can't be blank")
        end
        it "first_name_kanaが全角カタカナではないので登録できない" do
          @user.first_name_kana = "あ"
          @user.valid?
          expect(@user.errors.full_messages).to include("First name kana is invalid")
        end
        it "last_name_kanaが全角カタカナではないので登録できない" do
          @user.last_name_kana = "あ"
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name kana is invalid")
        end
        it "birthが空では登録できない" do
          @user.birth = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Birth can't be blank")
        end
      end
    end
  end
end