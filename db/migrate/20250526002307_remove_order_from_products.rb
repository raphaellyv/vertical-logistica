class RemoveOrderFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_reference :products, :order, null: false, foreign_key: false
  end
end
