class AddDefaultToOrders < ActiveRecord::Migration[8.0]
  def change
    change_column_default :orders, :total, from: nil, to: 0
  end
end
