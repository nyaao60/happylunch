require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'create' do
    let!(:user) { build(:user) }
  
    context 'userを正常に登録できる場合' do
    
      it '正常に登録できる' do
        expect(user).to be_valid
      end 
    end  

    context 'userを正常に登録できない場合' do
      let!(:user) { build(:user) }
      
      context '名前が空の場合' do
        before {user.name=''}
        
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end
      
      context '名前が16文字以上の場合' do
        before{user.name='a'*16}
    
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end

      context 'メールアドレスが空の場合' do
        before{user.email=''}
  
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end
        
      context 'メールアドレスが256文字以上の場合' do
        before{user.email="'aaaaa'@#{'a'*246}.com"}
        
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end

      context '重複したメールアドレスの場合' do
        let!(:other_user) { build(:user) }
        before do
          other_user.email=user.email 
          user.save
        end

        it 'バリデーションエラー' do
          expect(other_user).to be_invalid
        end
      end

      context '無効なメールアドレスフォーマットの場合' do
        before do
          invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
          invalid_addresses.each do |invalid_address|
            user.email = invalid_address
          end  
        end

        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end 

      context 'パスワードが空欄の場合' do
        before do
          user.password = ''
          user.password_confirmation = ''
        end
        
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end

      context 'パスワード確認が空欄の場合' do
        before{user.password_confirmation = ''}
      
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end

      context 'パスワードとパスワード確認が異なる場合' do
        before{user.password_confirmation = 'a'*6}
        
        it 'バリデーションエラー' do
          expect(user).to be_invalid
        end
      end

      context 'パスワードが６文字未満の場合' do
        before do
          user.password = 'a'*5
          user.password_confirmation = 'a'*5
        end
      
        it 'バリデーションエラー' do
          expect(user).to be_invalid   
        end  
      end 
    end 
  end

  describe "フォロー関連メソッド" do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    
    context'follow'do
    
      it 'フォローができること' do 
        expect { user.follow(other_user.id) }.to change { Relationship.count }.by(1) 
      end
    end    
    
    context'unfollow' do
      before{user.follow(other_user.id)}
      
      it 'フォロー解除できること' do
        expect { user.unfollow(other_user) }.to change { Relationship.count }.by(-1)
      end
    end

    context 'following' do
      context 'フォローしている場合' do
        before{user.follow(other_user.id)}
      
        it'フォロー一覧に存在すること' do
          expect(user.following?(other_user)).to eq true
        end
      end

      context 'フォローしていない場合'  do
    
        it 'フォロー一覧に存在しないこと' do
          expect(user.following?(other_user)).to eq false
        end
      end
    end
  end

  describe "削除の依存性検証" do  
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    context 'ユーザーと投稿が紐づく場合' do
      before{create(:post, user: user)}
      
      it '削除すると紐づく投稿も削除されること' do
        expect { user.destroy }.to change(user.posts, :count).by(-1)
      end
    end

    context 'ユーザーとお気に入りが紐づく場合' do
      before{create(:like, user: user)}

      it '削除すると紐づくお気に入りも削除されること' do
        expect { user.destroy }.to change(user.likes, :count).by(-1)
      end
    end

    context 'ユーザーが他のユーザーをフォローしている場合' do
      before{user.follow(other_user.id)}

      it '削除するとユーザーのフォロー一覧から削除されること' do
        expect { user.destroy }.to change(user.following, :count).by(-1)
      end

      it '削除すると他のユーザーのフォロワー一覧から削除されること' do
        expect { user.destroy }.to change(other_user.followers, :count).by(-1)
      end
    end

    context 'ユーザーとコメントが紐づく場合' do
      before{ create(:comment, user: user)}
    
      it '削除すると紐づくコメントも削除されること' do
        expect { user.destroy }.to change(user.comments, :count).by(-1)
      end
    end
  end  
end