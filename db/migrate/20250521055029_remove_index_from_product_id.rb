class RemoveIndexFromProductId < ActiveRecord::Migration[8.0]
  def change
    remove_index :products, :product_id
  end
end
