class CreateCreditCardPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_card_payments do |t|
      t.integer :order_id, null: false, index: { unique: true }
      t.integer :amount, null: false
      t.string :state, null: false
      t.string :transaction_identifier
      t.datetime :authorization_expires_at

      t.index [:state, :authorization_expires_at], name: :index_ccp_on_state_and_authorization_expires_at

      t.timestamps
    end
  end
end
