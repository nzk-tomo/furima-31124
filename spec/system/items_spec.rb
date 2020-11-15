require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER'] 
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "商品出品", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '商品出品ができるとき'do
    it 'ログインしたユーザーは商品出品できる' do
      # basic認証を突破
      basic_pass root_path
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      # 出品ページに移動する
      visit new_item_path
      # フォームに情報を入力する
      attach_file "item[image]", "public/images/test_image.png"
      fill_in 'item[name]', with: @item.image
      fill_in 'item[description]', with: @item.description
      select @item.category.name, from: 'item[category_id]'
      select @item.condition.name, from: 'item[condition_id]'
      select @item.shipping_fee.name, from: 'item[shipping_fee_id]'
      select Prefectures.data[@item.ship_from_id - 1 ][:name], from: 'item[ship_from_id]'
      select @item.delivery_date.name, from: 'item[delivery_date_id]'
      fill_in 'item[price]', with: @item.price
      # 送信するとItemモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # トップページには先ほど投稿した内容の商品が存在することを確認する（画像）
      expect(page).to have_selector "img[src$= 'test_image.png']"
      # トップページには先ほど投稿した内容の商品が存在することを確認する（テキスト）
      expect(page).to have_content(@item_name)
      expect(page).to have_content(@item_price)
      expect(page).to have_content(@item.shipping_fee.name)
    end
  end
  context '商品出品ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # basic認証を突破
      basic_pass root_path
      # トップページに遷移する
      expect(current_path).to eq root_path
      # 新規投稿ページへのリンクがない
      expect(page).to have_no_content('出品する')
    end
  end
end

RSpec.describe '商品編集・削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したツイートの編集ができる' do
      # item1を投稿したユーザーでログインする
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # item1の商品詳細ページへ遷移する
      visit item_path(@item1.id)
      # item1に「編集」ボタンがあることを確認する
      expect(page).to have_link '商品の編集' , href: edit_item_path(@item1)
      # 編集ページへ遷移する
      visit edit_item_path(@item1.id)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(@item1.image).to eq @item1.image
      expect(find('#item-name').value).to eq @item1.name
      expect(find('#item-info').value).to eq @item1.description
      expect(find('#item_category_id').value).to eq @item1.category_id.to_s
      expect(find('#item_condition_id').value).to eq @item1.condition_id.to_s
      expect(find('#item-shipping-fee-status').value).to eq @item1.shipping_fee_id.to_s
      expect(find('#item-prefecture').value).to eq @item1.ship_from_id.to_s
      expect(find('#item-scheduled-delivery').value).to eq @item1.delivery_date_id.to_s
      expect(find('#item-price').value).to eq @item1.price.to_s
      # 投稿内容を編集する
      attach_file "item[image]", "public/images/test_image2.png"
      fill_in 'item[name]', with: "#{@item1.name}+編集後の名前"
      fill_in 'item[description]', with: "#{@item1.description}+編集後説明"
      select Category.data[1][:name], from: 'item[category_id]'
      select Condition.data[1][:name], from: 'item[condition_id]'
      select ShippingFee.data[1][:name], from: 'item[shipping_fee_id]'
      select Prefectures.data[1][:name], from: 'item[ship_from_id]'
      select DeliveryDate.data[1][:name], from: 'item[delivery_date_id]'
      fill_in 'item[price]', with: @item1.price + 300
      # 編集してもTweetモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(0)
      # 商品詳細画面に遷移したことを確認する
      expect(current_path).to eq item_path(@item1.id)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど変更した内容のツイートが存在することを確認する（画像）
      expect(page).to have_selector "img[src$= 'test_image2.png']"
      # トップページには先ほど変更した内容のツイートが存在することを確認する（テキスト）
      expect(page).to have_content("#{@item1.name}+編集後の名前")
      expect(page).to have_content(@item1.price + 300)
      expect(page).to have_content(ShippingFee.data[1][:name])
    end
  end
  context '商品削除ができるとき' do
    it 'ログインしたユーザーは自分が投稿した商品の削除ができる' do
      # item1を投稿したユーザーでログインする
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # item1の商品詳細ページへ遷移する
      visit item_path(@item1.id)
      # item1に「編集」ボタンがあることを確認する
      expect(page).to have_link '削除' , href: item_path(@item1)
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        find_link('削除' , href: item_path(@item1)).click
      }.to change { Item.count }.by(-1)
      # トップページに遷移する
      visit root_path
      # トップページにはitem1の内容が存在しないことを確認する（画像）
      expect(page).to have_no_selector @item1.image.key
      # トップページには先ほど投稿した内容の商品が存在しないことを確認する（テキスト）
      expect(page).to have_no_content(@item1.name)
      expect(page).to have_no_content(@item1.price)
      expect(page).to have_no_content(@item1.shipping_fee.name)
    end
  end
  context '商品編集・削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した商品の編集・削除ボタンが画面に表示されない' do
      # item1を投稿したユーザーでログインする
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: @item1.user.email
      fill_in 'password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # item2の商品詳細ページへ遷移する
      visit item_path(@item2.id)
      # item2に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item2)
      # item2に「削除」ボタンがないことを確認する
      expect(page).to have_no_link '削除', href: edit_item_path(@item2)
    end
    it 'ログインしていないと商品の編集・削除ボタンが画面に表示されない' do
      # トップページにいる
      basic_pass root_path
      # item1に「編集」ボタン・「削除」ボタンがないことを確認する
      visit item_path(@item1.id)
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item1)
      expect(page).to have_no_link '削除', href: edit_item_path(@item1)
      # item2に「編集」ボタン・「削除」ボタンがないことを確認する
      visit item_path(@item2.id)
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item2)
      expect(page).to have_no_link '削除', href: edit_item_path(@item2)
    end
    context '商品が購入されているとき' do
      it '購入された商品の編集編集・削除ボタンは画面に表示されない' do
        # item2を投稿したユーザーでログインする
        basic_pass root_path
        visit new_user_session_path
        fill_in 'email', with: @item2.user.email
        fill_in 'password', with: @item2.user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # item1に「購入」ボタンがあることを確認する
        visit item_path(@item1.id)
        expect(page).to have_link '購入画面に進む', href: item_trades_path(@item1)
        # 商品購入画面に遷移する
        visit item_trades_path(@item1)
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
        expect(current_path).to eq item_trades_path(@item1)
        # sold outと表示されているか確認する
        expect(page).to have_selector '.sold-out',text: 'Sold Out!!'
        visit item_path(@item1.id)
        expect(page).to have_selector '.sold-out',text: 'Sold Out!!'
        # item2のユーザーではitem1に「編集」・「削除」ボタンがないことを確認する
        expect(page).to have_no_link '商品の編集', href: edit_item_path(@item1)
        expect(page).to have_no_link '削除', href: edit_item_path(@item1)
        # ログインしていないユーザーではitem1に「編集」・「削除」ボタンがないことを確認する
        visit root_path
        expect(page).to have_link 'ログアウト' , href: destroy_user_session_path
        find('.logout').click
        expect(current_path).to eq root_path
        visit item_path(@item1.id)
        expect(page).to have_no_link '商品の編集', href: edit_item_path(@item1)
        expect(page).to have_no_link '削除', href: edit_item_path(@item1)
        # 購入済みだとitem1のユーザーでもitem1に「編集」・「削除」ボタンがないことを確認する
        visit root_path
        visit new_user_session_path
        fill_in 'email', with: @item1.user.email
        fill_in 'password', with: @item1.user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        visit item_path(@item1.id)
        expect(page).to have_no_link '商品の編集', href: edit_item_path(@item1)
        expect(page).to have_no_link '削除', href: edit_item_path(@item1)
      end
    end
  end
end