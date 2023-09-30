class Tag < ApplicationRecord
  has_many :post_tag_relations, dependent: :destroy
  has_many :posts,through: :post_tag_relations 
  validates :tag_name, presence:true, length:{maximum:10}
end
