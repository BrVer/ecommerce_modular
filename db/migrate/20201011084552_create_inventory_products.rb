class CreateInventoryProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_products do |t|
      t.string :name
      t.integer :current_price
      t.integer :available_quantity

      t.timestamps
    end
  end
end
