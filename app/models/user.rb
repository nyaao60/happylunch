class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes,dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :active_relationships,
  class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships,class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships,  source: :follower
  
  mount_uploader :image, ImageUploader

  before_save   :downcase_email

  validates :name,  presence: true, length: { maximum: 15 },uniqueness:true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },allow_nil: true

  attr_accessor :remember_token

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # 上記は、BCrypt::Password.new(DBのハッシュ化されたパスワード) == '打ち込んだ生パスワード'の意味

    def forget
      update_attribute(:remember_digest,nil)
    end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end

end
