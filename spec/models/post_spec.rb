require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'create' do
    let!(:user){create(:user)}
    let!(:post) {build(:post, user: user) }

    context '投稿を正常に保存できる場合' do

      it '正しく保存できること' do
        expect(post).to be_valid
      end
    end

    context '投稿を正常に保存できない場合' do
  
      context '店名が空欄の場合' do
        before  {post.store_name = ''}
      
        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end

      context '店名が31文字以上の場合' do
        before{post.store_name = 'a' * 31}
        
        it 'バリデーションエラー'do      
          expect(post).to be_invalid
        end
      end

      context '住所が空欄の場合' do
        before{post.address = ''}

        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end

      context '住所が61文字以上の場合' do
        before {post.address = 'a' * 61}

        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end

      context '価格が空欄の場合' do
        before{post.price = ''}
      
        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end
      
      context '価格が0円の場合' do
        before{post.price = 0}
        
        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end

      context '価格が801円以上の場合' do
        before{post.price = 801}

        it 'バリデーションエラー'do
        expect(post).to be_invalid
        end
      end
      
      context '画像の添付がない場合' do
      
        before{post.post_images = []}
        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end

      context '内容が空欄の場合' do
        before{post.body = ''}
        
        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end

      context '内容が401文字以上の場合' do
        before{post.body = 'a' * 401}

        it 'バリデーションエラー'do
          expect(post).to be_invalid
        end
      end
    end
  end

  describe '#liked_by' do
    let! (:post) { create(:post) }
    let! (:user) { create(:user) }
    
    context 'ユーザが投稿にいいね済みの場合' do
      before do
        like = FactoryBot.create(:like, post: post, user: user)
        like.save!
      end

      it 'trueを返すこと' do
        expect(post.liked_by(user)).to eq true
      end
    end

    context 'ユーザが投稿にいいねしていない場合' do
      before do
        like = FactoryBot.build(:like, post: post) 
        like.save!
      end

      it 'falseを返すこと' do
        expect(post.liked_by(user)).to eq false
      end
    end
  end
end