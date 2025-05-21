class AddIndexToOrderId < ActiveRecord::Migration[8.0]
  def change
    add_index :orders, :order_id, unique: true
  end
end
