class RenameAdressColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts,:adress, :address
  end
end