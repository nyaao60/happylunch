class ChangeDataPostImagesToPost < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :post_images, :json
  end
end
