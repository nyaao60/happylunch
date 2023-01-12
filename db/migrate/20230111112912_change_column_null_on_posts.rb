class ChangeColumnNullOnPosts < ActiveRecord::Migration[6.0]
  def change
    change_column_null :posts, :latitude, true
    change_column_null :posts, :longtitude, true
  end
end
