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
      end

      context '新規登録がうまくいかないとき' do
        it 'nicknameが空だと登録できない' do
          @user.nickname = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Nickname can't be blank")
        end
        it 'emailが空では登録できない' do
          @user.email = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Email can't be blank")
        end
        it 'emailに@が含まれていないため登録できない' do
          n = @user.email.index('@')
          @user.email.slice!(n)
          @user.valid?
          expect(@user.errors.full_messages).to include('Email is invalid')
        end
        it 'emailが重複している場合登録できない' do
          @user.save
          another_user = FactoryBot.build(:user, email: @user.email)
          another_user.valid?
          expect(another_user.errors.full_messages).to include('Email has already been taken')
        end
        it 'passwordが空では登録できない' do
          @user.password = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Password can't be blank")
        end
        it 'passwordが数字のみであれば登録できない' do
          @user.password = '000000'
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it 'passwordが半角英字のみであれば登録できない' do
          @user.password = 'aaaaaa'
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it 'passwordに全角英字が含まれるため登録できない' do
          @user.password = 'Ａaaaa0'
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it 'passwordが5文字以下であれば登録できない' do
          @user.password = 'aaaa5'
          @user.valid?
          expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
        end
        it 'passwordが存在してもpassword_confirmationが空では登録できない' do
          @user.password_confirmation = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
        it 'first_nameが空では登録できない' do
          @user.first_name = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("First name can't be blank")
        end
        it 'last_nameが空では登録できない' do
          @user.last_name = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name can't be blank")
        end
        it 'first_nameに半角英字が含まれるため登録できない' do
          @user.first_name = 'a'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name は全角で入力願います')
        end
        it 'last_nameに半角英字が含まれるため登録できない' do
          @user.last_name = 'a'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name は全角で入力願います')
        end
        it 'first_nameに全角英字が含まれるため登録できない' do
          @user.first_name = 'Ａ'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name は全角で入力願います')
        end
        it 'last_nameに全角英字が含まれるため登録できない' do
          @user.last_name = 'Ａ'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name は全角で入力願います')
        end
        it 'first_nameに半角カタカナが含まれるため登録できない' do
          @user.first_name = 'ｱ'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name は全角で入力願います')
        end
        it 'last_nameに半角カタカナが含まれるため登録できない' do
          @user.last_name = 'ｱ'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name は全角で入力願います')
        end
        it 'first_nameに数字が含まれるため登録できない' do
          @user.first_name = '1'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name は全角で入力願います')
        end
        it 'last_nameに数字が含まれるため登録できない' do
          @user.last_name = '1'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name は全角で入力願います')
        end
        it 'first_name_kanaが空では登録できない' do
          @user.first_name_kana = ''
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaが空では登録できない' do
          @user.last_name_kana = ''
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'first_name_kanaにひらがなが含まれるため登録できない' do
          @user.first_name_kana = 'あ'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaにひらがなが含まれるため登録できない' do
          @user.last_name_kana = 'あ'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'first_name_kanaに漢字が含まれるため登録できない' do
          @user.first_name_kana = '亜'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaに漢字が含まれるため登録できない' do
          @user.last_name_kana = '亜'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'first_name_kanaに半角カタカナが含まれるため登録できない' do
          @user.first_name_kana = 'ｱ'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaに半角カタカナが含まれるため登録できない' do
          @user.last_name_kana = 'ｱ'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'first_name_kanaに半角英字が含まれるため登録できない' do
          @user.first_name_kana = 'a'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaに半角英字が含まれるため登録できない' do
          @user.last_name_kana = 'a'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'first_name_kanaに全角英字が含まれるため登録できない' do
          @user.first_name_kana = 'ａ'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaに全角英字が含まれるため登録できない' do
          @user.last_name_kana = 'ａ'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'first_name_kanaに数字が含まれるため登録できない' do
          @user.first_name_kana = '1'
          @user.valid?
          expect(@user.errors.full_messages).to include('First name kana は全角カタカナで入力願います')
        end
        it 'last_name_kanaに数字が含まれるため登録できない' do
          @user.last_name_kana = '1'
          @user.valid?
          expect(@user.errors.full_messages).to include('Last name kana は全角カタカナで入力願います')
        end
        it 'birthが空では登録できない' do
          @user.birth = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Birth can't be blank")
        end
      end
    end
  end
end
