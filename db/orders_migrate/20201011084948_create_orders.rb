class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :state, null: false
      t.string :cancel_reason

      t.timestamps
    end
  end
end
