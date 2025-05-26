class AddUniqueIndexToProductItems < ActiveRecord::Migration[8.0]
  def change
    add_index :product_items, [:product_id, :order_id], unique: true
  end
end
