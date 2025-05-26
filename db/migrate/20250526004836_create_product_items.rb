class CreateProductItems < ActiveRecord::Migration[8.0]
  def change
    create_table :product_items do |t|
      t.references :product, null: false
      t.references :order, null: false

      t.timestamps
    end
  end
end
