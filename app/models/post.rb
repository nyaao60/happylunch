class Post < ApplicationRecord
  belongs_to :user
  has_many :likes,dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :post_tag_relations, dependent: :destroy
  has_many :tags,through: :post_tag_relations

  validates :user_id, presence: true
  validates :store_name, presence: true , length: { maximum: 30} 
  validates :lunch_name, presence: true , length: { maximum: 30} 
  validates :address, presence: true,length: { maximum: 60}
  validates :price, presence: true,numericality: { within: 1..1500 }
  validates :body, presence: true,length: { maximum: 400}
  validates :post_images,presence: true

  validate :tag_count_within_limit
  
  mount_uploaders :post_images, ImageUploader
  
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def liked_by(user_id)
    likes.where(user_id: user_id).exists?
  end  

  def save_tags(tag_list)
    self.tag_ids = tag_list.map do |new_tag|
      Tag.find_or_create_by(tag_name: new_tag).id
    end
  end

  def update_tags(latest_tags)
    if self.tags.empty?
      self.tag_ids = latest_tags.map do |new_tag|
        Tag.find_or_create_by(tag_name: new_tag).id
      end
    elsif latest_tags.empty?
      self.tag_ids = []
    else
      current_tags = self.tags.pluck(:tag_name)  
      old_tags = current_tags - latest_tags
      new_tags = latest_tags - current_tags
  
      old_tags.each do |old|
        self.tags.delete Tag.find_by(tag_name: old)
      end
  
      new_tag_ids = new_tags.map do |new|
        Tag.find_or_create_by(tag_name: new).id
      end
  
      self.tag_ids = (self.tag_ids - old_tags.map { |tag| Tag.find_by(tag_name: tag).id }) + new_tag_ids
    end
  end  

  def self.search(search)
    if search != ""
      Post.where(["store_name LIKE ? OR lunch_name LIKE ? OR body LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%"])
    end
  end

  class << self
    def within_box(distance, latitude,longitude)
      distance = distance
      center_point = [latitude, longitude]
      box = Geocoder::Calculations.bounding_box(center_point, distance)
      # bounding_boxは、指定された点を中心とするボックスの左下隅と右上隅の座標を返す。半径は、中心点からボックスの任意の辺までの最短距離
      self.within_bounding_box(box)
    end
  end

  private

  def tag_count_within_limit
    if tags.size > 4
      errors.add(:tags, "は4つまでです")
    end
  end
end