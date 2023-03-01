class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true,length: { maximum: 200 }
end