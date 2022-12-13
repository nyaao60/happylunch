class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :store_name, null: false
      t.string :adress, null: false
      t.float :latitude, null: false
      t.float :longtitude, null: false
      t.integer :price, null: false
      t.integer :five_star_rating, null: false
      t.boolean :lots_of_vegetables, null: false,default: false
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
