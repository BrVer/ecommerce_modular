class CreateOrderLines < ActiveRecord::Migration[7.0]
  def change
    create_table :order_lines do |t|
      t.references :order, null: false, foreign_key: true
      t.bigint :product_id, null: false
      t.integer :quantity, null: false
      t.boolean :reserved, null: false, default: false
      t.integer :price_at_submit

      t.timestamps
    end
  end
end
