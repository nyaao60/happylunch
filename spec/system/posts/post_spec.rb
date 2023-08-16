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
            fill_in 'おすすめのランチ', with: 'テストランチ'
            fill_in '住所', with: '大阪府大阪市北区大深町４−２０'
            attach_file 'ランチ画像', Rails.root.join('spec', 'fixtures', 'sample.png') 
            fill_in 'post[price]', with: '600'
            check 'post[lots_of_vegetables]'
            fill_in 'post[body]', with: 'とても美味しかったです！'
            click_button '投稿'
            expect(page).to have_content '投稿しました'
            expect(page).to have_content 'テスト店'
            expect(page).to have_content 'テストランチ'
            expect(page).to have_content '600円'
            expect(page).to have_content 'とても美味しかったです！'
        end
    end

    describe '投稿の削除、更新関係' do
        let!(:login_user) { create(:user) }
        let!(:login_user_post) { create(:post, user: login_user)}
        let!(:other_user_post) { create(:post) }
        
        before do
            login_as login_user 
        end 

        context '自分の投稿の場合' do
        
            it '編集ボタンが表示され編集ができること' do
                visit post_path(login_user_post.id)
                expect(page).to have_css '#post-edit-btn'
                find("#post-edit-btn").click
                attach_file 'ランチ画像', Rails.root.join('spec', 'fixtures', 'sample.png')
                fill_in 'post[body]', with: 'とっても美味しかったです！'
                click_button '更新'
                expect(page).to have_content '投稿を更新しました！'
                expect(page).to have_content 'とっても美味しかったです！'
            end

            it '削除ボタンが表示され削除できること' do
                visit post_path(login_user_post.id)
                expect(page).to have_css '#post-delete-btn'
                expect{
                    find("#post-delete-btn").click
                    }
                    .to change{Post.where(user_id:login_user.id).count}.by(-1)
            end
        end

        context '他人の投稿の場合' do
            
            it '削除ボタンが表示されないこと' do
                visit post_path(other_user_post.id)
                expect(page).to_not have_css ".post-delete-btn"
            end

            it '編集ボタンが表示されないこと' do
                visit post_path(other_user_post.id)
                expect(page).to_not have_css '.post-edit-btn'
            end
        end
    end

    describe 'いいね' do
        let!(:user) { create(:user) }
        let!(:post) { create(:post) }
        
        before do
            login_as user
        end
        
        it '投稿にいいねができること' do
            visit post_path(post.id)
            expect{
            find(".unliked-btn") .click
            }
            .to change { Like.where(post_id:post.id).count}.by(1)
            expect(page).to have_css '.liked-button'            
        end

        it '投稿のいいねを取り消せること' do
            visit post_path(post.id)
            find(".unliked-btn") .click
            expect{
            find(".liked-btn") .click
            }
            .to change { Like.where(user_id:user.id).count}.by(-1)
            expect(page).to have_css '.unliked-button'            
        end
    end

    describe 'コメント' do
        let!(:user) { create(:user) }
        let!(:post) { create(:post) }
        let!(:post2) { create(:post) }
        let!(:comment_user) { create(:user) }
        let!(:comment) { create(:comment, user:comment_user,post:post2)}

        before do
            login_as comment_user
        end
        
        it 'コメントができること' do
            visit post_path(post.id)
            fill_in 'comment[content]', with: 'テストコメントをしました'   
            click_button 'コメントする'
            expect(page).to have_content 'テストコメントをしました'
        end

        it 'コメントを削除できること' do
            visit post_path(post2.id)
            expect{
            find("#comment-delete-btn") .click
            }
            .to change { Comment.where(user_id:comment_user.id).count}.by(-1)
            expect(page).to_not have_content 'b' * 10 
        end
    end
end