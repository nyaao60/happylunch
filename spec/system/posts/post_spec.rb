require 'rails_helper'

RSpec.describe '投稿', type: :system do
    describe "投稿一覧に関して" do
        let!(:login_user) { create(:user) }
        let!(:follow_user) { create(:user) }
        let!(:other_user) { create(:user) }
        let!(:post) { create(:post) }
        let!(:login_user_post) { create(:post, user: login_user) }
        let!(:follow_user_post) { create(:post, user: follow_user) }
        let!(:other_user_post) { create(:post, user: other_user) }

        context "ログインしている場合" do 
            before do
                login_as login_user
                login_user.follow(follow_user.id)
            end

            it 'home画面にフォローしているユーザーと自分の投稿のみ表示される' do
                visit root_path 
                expect(page).to have_content login_user_post.store_name
                expect(page).to have_content follow_user_post.store_name
                expect(page).to_not have_content other_user_post.store_name
            end
        end

        context "ログインしていない場合" do
            it 'home画面に全ての投稿が表示される' do
                visit root_path 
                expect(page).to have_content login_user_post.store_name
                expect(page).to have_content follow_user_post.store_name
                expect(page).to have_content other_user_post.store_name
            end
        end  
    end

    describe '投稿機能' do
        it '投稿できること' do
            login
            visit new_post_path
            fill_in '店名', with: 'テスト店'
            fill_in '住所', with: '大阪府大阪市北区大深町４−２０'
            attach_file '写真', Rails.root.join('spec', 'fixtures', 'sample.png') 
            fill_in 'post[price]', with: '600'
            check 'post[lots_of_vegetables]'
            fill_in 'post[body]', with: 'とても美味しかったです！'
            click_button '投稿'
            expect(page).to have_content '投稿しました'
            expect(page).to have_content 'テスト店'
            expect(page).to have_content '600円'
            expect(page).to have_content 'とても美味しかったです！'
        end
    end
end