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

      # it 'メールアドレスの一意性'
      #   other_user= user.dup
      #   user.save
      #   expect(other_user).to be_invalid
      #   # expect(other_user.errors[:email]).to include('はすでに存在します')
      # end

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
end