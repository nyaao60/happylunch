class AddLunchNameToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :lunch_name, :string,null: false
  end
end
