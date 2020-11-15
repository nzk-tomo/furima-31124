require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER'] 
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "コメント投稿", type: :system do
  let(:user) {FactoryBot.create(:user)}
  let(:item) {FactoryBot.create(:item)}

  context 'コメント投稿ができるとき'do
    it 'ログインしたユーザーはコメント投稿できる' do
      # itemを投稿したユーザーでログインする
      basic_pass root_path
      visit new_user_session_path
      fill_in 'email', with: item.user.email
      fill_in 'password', with: item.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品詳細ページへ遷移する
      visit item_path(item.id)
      # ページに「コメントする」ボタンがあることを確認する
      expect(page).to have_content('コメントする')
      # コメントをする
      fill_in 'comment[comment]', with: "test"
      # 送信するとCommentモデルのカウントが1上がることを確認する
      expect{
        find('.comment-btn').click
      }.to change { Comment.count }.by(1)
      # コメント内容があるか確認
      expect(page).to have_selector '.comments_list',text: 'test'
      expect(page).to have_selector '.comments_list',text: item.user.nickname
    end
  end
end