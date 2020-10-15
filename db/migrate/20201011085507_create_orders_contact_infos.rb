class CreateOrdersContactInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :orders_contact_infos do |t|
      t.references :orders_order, null: false, foreign_key: true
      t.string :phone, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
