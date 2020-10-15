class CreatePaymentsCreditCardPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments_credit_card_payments do |t|
      t.references :orders_order, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :state, null: false
      t.string :transaction_identifier

      t.timestamps
    end
  end
end
