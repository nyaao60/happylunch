class Post < ApplicationRecord
  belongs_to :user
  has_many :likes,dependent: :destroy
  has_many :comments,dependent: :destroy
  validates :user_id, presence: true
  validates :store_name, presence: true  
  validates :adress, presence: true
  validates :price, presence: true,numericality: { in: 1..700 }
  mount_uploader :post_images, ImageUploader
end