class RemoveTotalFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :total
  end
end
