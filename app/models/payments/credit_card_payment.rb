class Payments::CreditCardPayment < ApplicationRecord
  belongs_to :orders_order
end
