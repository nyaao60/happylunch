require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'create' do
    let!(:user) {create(:user)}
    let!(:post) {create(:post,user:user)}
    
    context '正常に保存できる場合' do
      let!(:comment) { build(:comment,post:post,user:user) }
    
      it '正常に登録できること' do
        expect(comment).to be_valid    
      end
    end

    context '正常に保存できない場合' do
      let!(:comment) {build(:comment)}

      context 'user_idが存在しない場合' do
        before {user_id = nil}
        
        it 'バリデーションエラー' do
          expect(comment).to be_invalid
        end
      end

      context 'post_idが存在しない場合' do
        before{post_id = nil}
        
        it 'バリデーションエラー' do
          expect(comment).to be_invalid
        end
      end
    
      context 'コメント内容が201文字以上の場合' do
        before{comment.content = 'a' * 201}
    
        it 'バリデーションエラー' do
          expect(comment).to be_invalid
        end
      end  
    end
  end
end