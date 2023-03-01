require 'rails_helper'
RSpec.describe '登録', type: :system do
  describe "ユーザー登録" do
    context "正常系" do
              
        it '登録成功' do
          visit new_user_path
          fill_in 'ユーザー名', with: 'test'
          fill_in 'メールアドレス', with: 'rails@example.com'
          fill_in 'パスワード', with: '12345678'
          fill_in 'パスワード(確認)', with: '12345678'
          click_button '登録'
          user_id = User.find_by(email: 'rails@example.com').id
          expect(current_path).to eq "/users/#{user_id}"
          expect(page).to have_content 'ようこそ、ハピランチへ！'
        end
      end  

      context '異常系' do
      
        it '登録失敗' do
          visit new_user_path
          fill_in 'ユーザー名', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: '1'
          fill_in 'パスワード(確認)', with: '12345678'
          click_button '登録'
          expect(page).to have_content 'ユーザー名を入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'メールアドレスは不正な値です'
          expect(page).to have_content 'パスワードは6文字以上で入力してください'
          expect(page).to have_content 'ユーザーの作成に失敗しました'
        end
      end
    end

  describe "フォロー関係" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
      login_as user1
    end

    it 'フォローができること' do
      visit users_path
      expect {
      find(" #follow-form-#{user2.id}") .click
      }.to change { Relationship.where(follower_id:user1.id,followed_id:user2.id).count }.by(1)
      expect(page).to have_content 'フォロー中'
    end

    it 'フォローが解除できること'  do
      visit users_path
      find(" #follow-form-#{user2.id}") .click
      expect{
      find(" #unfollow-form-#{user2.id}") .click
      }.to change { Relationship.where(follower_id:user1.id,followed_id:user2.id).count }.by(-1)
      expect(page).to have_content 'フォロー'
    end  
  end
end