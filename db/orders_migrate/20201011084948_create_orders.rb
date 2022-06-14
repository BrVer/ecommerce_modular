class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.bigint :user_id, null: false, index: true
      t.string :state, null: false

      t.timestamps
    end
  end
end
