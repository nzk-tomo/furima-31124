require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER'] 
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "商品購入", type: :system do
    let(:user) {FactoryBot.create(:user)}
    let(:item) {FactoryBot.create(:item)}

  context '商品購入ができるとき'do
    it 'ログインしたユーザーは商品購入できる' do
      # itemを投稿していないユーザーでログインする
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # itemに「購入」ボタンがあることを確認する
      visit item_path(item.id)
      expect(page).to have_link '購入画面に進む', href: item_trades_path(item)
      # 商品購入画面に遷移する
      visit item_trades_path(item)
      # 商品を購入する
      fill_in 'item_trade[number]', with: "4242424242424242"
      fill_in 'item_trade[exp_month]', with: "12"
      fill_in 'item_trade[exp_year]', with: "22"
      fill_in 'item_trade[cvc]', with: "123"
      fill_in 'item_trade[postal_code]', with: "123-4567"
      select Prefectures.data[1][:name], from: 'item_trade[prefecture_id]'
      fill_in 'item_trade[city]', with: "1"
      fill_in 'item_trade[address]', with: "1"
      fill_in 'item_trade[phone_number]', with: "09012345678"
      find('input[name="commit"]').click
      # モデルのカウントが上がっていることを確認
      change { Trade.count }.by(1) & change { Address.count }.by(1)
      # IndexとShowでsold outと表示されているか確認
      expect(page).to have_selector '.sold-out',text: 'Sold Out!!'
      visit item_path(item.id)
      expect(page).to have_selector '.sold-out',text: 'Sold Out!!'
    end
  end

  context '商品購入ができないとき'do
    it 'ログインしていないので購入ページに遷移できない' do
      # 商品詳細ページへ遷移する
      basic_pass root_path
      expect(current_path).to eq root_path
      visit item_path(item.id)
      # 商品購入ボタンがない
      expect(page).to have_no_link '購入画面に進む', href: item_trades_path(item)
    end
    it '出品者なので購入ページに遷移できない' do
      # 商品出品者でログイン
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: item.user.email
      fill_in 'password', with: item.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品詳細ページへ遷移する
      visit item_path(item.id)
      # 商品購入ボタンがない
      expect(page).to have_no_link '購入画面に進む', href: item_trades_path(item)
    end
    it 'すでに購入されているので購入ページに遷移できない' do
      # 購入してログアウトする
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      find('input[name="commit"]').click
      visit item_path(item.id)
      visit item_trades_path(item)
      fill_in 'item_trade[number]', with: "4242424242424242"
      fill_in 'item_trade[exp_month]', with: "12"
      fill_in 'item_trade[exp_year]', with: "22"
      fill_in 'item_trade[cvc]', with: "123"
      fill_in 'item_trade[postal_code]', with: "123-4567"
      select Prefectures.data[1][:name], from: 'item_trade[prefecture_id]'
      fill_in 'item_trade[city]', with: "1"
      fill_in 'item_trade[address]', with: "1"
      fill_in 'item_trade[phone_number]', with: "09012345678"
      find('input[name="commit"]').click
      expect(page).to have_link 'ログアウト' , href: destroy_user_session_path
      find('.logout').click
      expect(current_path).to eq root_path
      # 別のユーザーでサインイン
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動し別ユーザーでサインアップ
      visit new_user_registration_path
      fill_in 'nickname', with: "aaa"
      fill_in 'email', with: "a1@a"
      fill_in 'password', with: "111qqq"
      fill_in 'password-confirmation', with: "111qqq"
      fill_in 'first-name', with: "あ"
      fill_in 'last-name', with: "あ"
      fill_in 'first-name-kana', with: "ア"
      fill_in 'last-name-kana', with: "ア"
      select 1980,from: 'user_birth_1i'
      select 7,from: 'user_birth_2i'
      select 7,from: 'user_birth_3i'
      find('input[name="commit"]').click
      # 商品詳細ページへ遷移する
      visit item_path(item.id)
      # 商品購入ボタンがない
      expect(page).to have_no_link '購入画面に進む', href: item_trades_path(item)
    end
  end
end
