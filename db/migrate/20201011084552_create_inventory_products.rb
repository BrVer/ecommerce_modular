class CreateInventoryProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_products do |t|
      t.string :name, null: false
      t.integer :current_price, null: false
      t.integer :available_quantity, null: false
      t.integer :reserved_quantity, null: false, default: 0

      t.timestamps
    end
  end
end
