class AddUniqueIndexToProducts < ActiveRecord::Migration[8.0]
  def change
    add_index :products, [:product_id, :order_id], unique: true
  end
end
