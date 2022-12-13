class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes,dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships,class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships,  source: :follower

  before_save   :downcase_email
 
  validates :name,  presence: true, length: { maximum: 15 },uniqueness:true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },allow_nil: true

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

end
