class ChangeUsersNull < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.change :user_id, :bigint, null: false
      t.change :name, :string, null: false
    end
  end
end
