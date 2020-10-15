class CreateShippingInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :shipping_infos do |t|
      t.references :order, null: false, foreign_key: true
      t.string :receiver_name, null: false
      t.text :shipping_address, null: false

      t.timestamps
    end
  end
end
