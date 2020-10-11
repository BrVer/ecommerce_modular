class CreateOrdersOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_orders do |t|
      t.string :status

      t.timestamps
    end
  end
end
