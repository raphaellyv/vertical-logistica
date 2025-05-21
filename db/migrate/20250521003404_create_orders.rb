class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :order_id, null: false
      t.decimal :total, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
