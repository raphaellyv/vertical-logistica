class AddIndexToProductId < ActiveRecord::Migration[8.0]
  def change
    add_index :products, :product_id, unique: true
  end
end
