class CreateCreditCardPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_card_payments do |t|
      t.bigint :user_id, null: false, index: true
      t.bigint :order_id, null: false, index: { unique: true }
      t.integer :amount, null: false
      t.string :state, null: false
      t.string :transaction_identifier
      t.datetime :authorization_expires_at

      t.index %i[state authorization_expires_at], name: :index_ccp_on_state_and_authorization_expires_at

      t.timestamps
    end
  end
end
