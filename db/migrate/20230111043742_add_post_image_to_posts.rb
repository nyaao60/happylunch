class AddPostImageToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :post_images, :string
  end
end
