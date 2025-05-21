class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.bigint :product_id, null: false
      t.decimal :value, null: false

      t.timestamps
    end
  end
end
