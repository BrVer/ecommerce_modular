class CreateOrdersOrderLines < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_order_lines do |t|
      t.references :orders_order, null: false, foreign_key: true
      t.references :inventory_product, null: false, foreign_key: true
      t.integer :quantity
      t.integer :price_at_submit

      t.timestamps
    end
  end
end
