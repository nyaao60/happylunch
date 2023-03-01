require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe '#create' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    context '正常に保存できる場合' do
      let(:relationship) do
        build(
          :relationship,
          follower_id: user.id,
          followed_id: other_user.id
        )
      end

      it '正常に登録できること' do
        expect(relationship).to be_valid
      end
    end

    context '正常に保存できない場合' do
      let!(:relationship) do
        build(
          :relationship,
          follower_id: user.id,
          followed_id: other_user.id
        )
      end

      context 'follower_idが存在しない場合' do
        before{relationship.follower_id = nil}

        it 'バリデーションエラー' do
          expect(relationship).to be_invalid
        end
      end

      context 'followed_idが存在しない場合' do
        before{relationship.followed_id = nil}
        
        it 'バリデーションエラー' do
          expect(relationship).to be_invalid
        end
      end
    end

    context '一意性の確認' do
      let!(:relationship) do
        create(
          :relationship,
          follower_id: user.id,
          followed_id: other_user.id
        )
      end

      context 'followed_idとfollower_idの組み合わせが同じものを保存する場合' do
        let!(:uniquness_relationship) do
          build(
          :relationship,
          follower_id: relationship.follower_id,
          followed_id: relationship.followed_id
        )
        end
        it 'バリデーションエラー' do
          expect(uniquness_relationship).to be_invalid
        end
      end
    end
  end
end