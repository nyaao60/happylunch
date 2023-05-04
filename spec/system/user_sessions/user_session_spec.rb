require 'rails_helper'
RSpec.describe 'ログイン・ログアウト', type: :system do

    let!(:user) { create(:user) }

    describe 'ログイン' do
        context '認証情報が正しい場合' do
            it 'ログインができる' do
                visit root_path
                click_on 'ログイン'
                fill_in 'メールアドレス', with: user.email
                fill_in 'パスワード', with: user.password
                click_button'ログイン'
                expect(current_path).to eq(root_path)  
            end
        end   
        
        context "入力に誤りがある" do
            it 'ログインできない' do
                visit root_path
                click_on 'ログイン'
                fill_in 'メールアドレス', with: user.email
                fill_in 'パスワード', with: '1234'
                click_button'ログイン'
                expect(current_path).not_to eq(root_path) 
                expect(current_path).to eq(login_path)
            end
        end
    end

    describe '簡単ログイン' do
        it 'ログインできる' do
            visit login_path
            click_on 'ユーザー登録せずに機能を試したい方はこちら'
            expect(current_path).to eq(root_path)            
        end
    end
        
    describe "ログアウトできる" do
        before do
            login
        end
        
        it 'ログアウトの確認' do
            click_on 'ログアウト'
            expect(current_path).to eq (root_path) 
            expect(page).to have_content 'ログアウトしました'
        end
    end
end