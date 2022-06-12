class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :current_price, null: false
      t.integer :available_quantity, null: false
      t.integer :reserved_quantity, null: false, default: 0

      t.timestamps
    end
  end
end
