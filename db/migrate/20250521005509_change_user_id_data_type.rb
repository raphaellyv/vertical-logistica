class ChangeUserIdDataType < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.change :user_id, :bigint
    end
  end
end
