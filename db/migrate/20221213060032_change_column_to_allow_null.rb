class ChangeColumnToAllowNull < ActiveRecord::Migration[6.0]

  def up
    change_column_null :users, :activation_digest, null: true
  end

  def down
    change_column_null :users, :activation_digest, null: false
  end

end
  