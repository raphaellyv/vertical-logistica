class AddIndexToUserId < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :user_id, unique: true
  end
end
