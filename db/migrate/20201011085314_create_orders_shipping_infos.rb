class CreateOrdersShippingInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_shipping_infos do |t|
      t.references :orders_order, null: false, foreign_key: true
      t.string :receiver_name, null: false
      t.text :shipping_address, null: false

      t.timestamps
    end
  end
end
