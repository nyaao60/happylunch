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
          expect(current_path).to eq 'users/1'
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
          within "#follow-form-#{user2.id}" do
              click_link 'フォロー'
              expect(page).to have_content 'フォロー中'
          end
      }.to change { user1.following.count }.by(1)
    end

    it 'フォローが解除できること'  do
      visit users_path
      expect {
          within "#follow-form-#{user2.id}" do
              click_link 'フォローを解除する'
              expect(page).to have_content 'フォローする'
          end
      }.to change { user1.following.count }.by(-1)
    end
  end
end