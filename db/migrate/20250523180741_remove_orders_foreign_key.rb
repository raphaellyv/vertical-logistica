class RemoveOrdersForeignKey < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :orders, :users
  end
end
