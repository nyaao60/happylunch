class Post < ApplicationRecord
  belongs_to :user
  has_many :likes,dependent: :destroy
  has_many :comments,dependent: :destroy
  validates :user_id, presence: true
  validates :store_name, presence: true  
  validates :address, presence: true
  validates :price, presence: true,numericality: { in: 1..700 }
  mount_uploaders :post_images, ImageUploader
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  class << self
    def within_box(distance, latitude,longitude)
      distance = distance
      center_point = [latitude, longitude]
      box = Geocoder::Calculations.bounding_box(center_point, distance)
      # bounding_boxは、指定された点を中心とするボックスの左下隅と右上隅の座標を返す。半径は、中心点からボックスの任意の辺までの最短距離
      self.within_bounding_box(box)
    end
  end
end