class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post,counter_cache: :likes_count
  validates :user_id, presence: true
  validates :post_id, presence: true

  namespace :api, { format: 'json' } do
    resources :likes, only: [:index, :create, :destroy]
  end

  scope :filter_by_post, ->(post_id) { where(post_id: post_id) if post_id }
end