class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.integer :user_id, null: false
      t.integer :name, null: false

      t.timestamps
    end
  end
end
