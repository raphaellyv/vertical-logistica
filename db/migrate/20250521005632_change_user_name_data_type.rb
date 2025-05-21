class ChangeUserNameDataType < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.change :name, :string
    end
  end
end
