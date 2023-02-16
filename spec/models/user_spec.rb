require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'create' do

    context 'userを登録できる場合' do
      let(:user) { build(:user) }
      it '全ての入力が正常の場合、登録できること' do
        expect(user).to be_valid
      end 
    end  

    context 'userを登録できない場合' do
      let(:user) { build(:user) }

      it '名前が空のため保存不可' do
        user.name=''
        expect(user).to be_invalid
      end

      it '名前が16文字以上のため保存不可' do
        user.name='a'*16
        expect(user).to be_invalid
      end

      it 'メールアドレスが空のため保存不可' do
        user.email=''
        expect(user).to be_invalid
      end

      it 'メールアドレスが256文字以上のため保存不可' do
        user.email="'aaaaa'@#{'a'*246}.com"
        expect(user).to be_invalid
      end

      it '重複したメールアドレスがあれば保存不可' do
        other_user = user.dup
        user.save
        expect(other_user).to be_invalid
      end

      it '無効なメールアドレスフォーマットのため保存不可' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).to be_invalid
        end
      end 

      it 'パスワードが空欄のため保存不可' do
        user.password = ''
        user.password_confirmation = ''
        expect(user).to be_invalid
      end
    
      it 'パスワード確認が空欄のため保存不可' do
        user.password_confirmation = ''
        expect(user).to be_invalid
      end

      it 'パスワードとパスワード確認が異なるため保存不可' do
        user.password_confirmation = 'a'*6
        expect(user).to be_invalid
      end

      it 'パスワードが６文字未満のため保存不可' do
        user.password = 'a'*5
        user.password_confirmation = 'a'*5
        expect(user).to be_invalid   
      end  
    end 
  end

  describe "フォロー関連メソッド" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it 'フォローができること' do
      expect { user.follow(other_user.id) }.to change { Relationship.count }.by(1) 
      binding.pry
    end
    
    it 'フォローが解除できること' do
      user.follow(other_user.id)
      expect { user.unfollow(other_user) }.to change { Relationship.count }.by(-1)
    end
    
    it 'フォローしている場合 フォロー一覧に存在すること' do
      user.follow(other_user.id)
      expect(user.following?(other_user)).to eq true
    end

    it 'フォローしていない場合 フォロー一覧に存在しない' do
      expect(user.following?(other_user)).to eq false
    end
  end
    
  describe "削除の依存性検証" do  
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    
    it '削除すると紐づく投稿も削除されること' do
      create(:post, user: user)
      expect { user.destroy }.to change(user.posts, :count).by(-1)
    end

    it '削除すると紐づくお気に入りも削除されること' do
      create(:like, user: user)
      expect { user.destroy }.to change(user.likes, :count).by(-1)
    end

    it '削除すると紐づくフォローも削除されること' do
      user.follow(other_user.id)
      expect { user.destroy }.to change(user.following, :count).by(-1)
    end

    it '削除すると紐づくフォロワーも削除されること' do
      user.follow(other_user.id)
      expect { user.destroy }.to change(other_user.followers, :count).by(-1)
    end
  
    it '削除すると紐づくコメントも削除されること' do
      create(:comment, user: user)
      expect { user.destroy }.to change(user.comments, :count).by(-1)
    end
  end  
end