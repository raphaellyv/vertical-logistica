class ChangeOrderIdNull < ActiveRecord::Migration[8.0]
  def change
    change_table :orders do |t|
      t.change :order_id, :bigint, null:false
    end
  end
end
