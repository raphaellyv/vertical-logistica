class RemoveProductsForeignKey < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :products, :orders
  end
end
