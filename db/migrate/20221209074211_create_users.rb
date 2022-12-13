class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :self_introduction
      t.integer :point
      t.string :password_digest, null: false
      t.string :remember_digest
      t.boolean :admin, null: false, default: false
      t.string :activation_digest, null: false
      t.boolean :activated, null: false, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
    change_column_default :users, :admin, from: true, to: false
  end
end
