FactoryBot.define do
  factory :payments_credit_card_payment, class: 'Payments::CreditCardPayment' do
    orders_order { nil }
    amount { 1 }
    status { "MyString" }
    transaction_identifier { "MyString" }
  end
end
