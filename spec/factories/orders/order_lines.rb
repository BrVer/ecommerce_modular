FactoryBot.define do
  factory :orders_order_line, class: 'Orders::OrderLine' do
    orders_order { nil }
    inventory_product { nil }
    quantity { 1 }
    price_at_submit { 1 }
  end
end
