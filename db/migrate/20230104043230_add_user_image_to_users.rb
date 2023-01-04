class AddUserImageToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_image, :string
  end
end
