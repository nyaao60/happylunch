require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'create' do
    let!(:user) {create(:user)}
    let!(:post) {create(:post,user:user)}
    
    context '正常に保存できる場合' do
      let!(:like) { build(:like,post:post,user:user) }
    
      it '正常に登録できること' do
        expect(like).to be_valid    
      end
    end

    context '正常に保存できない場合' do
      let!(:like) {build(:like)}

      context 'user_idが存在しない場合' do
        before {user_id = nil}
        
        it 'バリデーションエラー' do
          expect(like).to be_invalid
        end
      end

      context 'post_idが存在しない場合' do
        before{post_id = nil}
        
        it 'バリデーションエラー' do
          expect(like).to be_invalid
        end
      end
    end

    context '一意性の確認' do
      let!(:like) { create(:like) }
      
      context 'user_idとpost_idの組み合わせが同じものを保存する場合' do
      
        let!(:uniquness_like) do
          build(
          :like,
          user_id: like.user_id,
          post_id: like.post_id
          )
        end
      
        it 'バリデーションエラー' do
          expect(uniquness_like).to be_invalid
        end
      end
    end  
  end
end  