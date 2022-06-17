# frozen_string_literal: true

FactoryBot.define do
  factory :orders_shipping_info, class: 'Orders::ShippingInfo' do
    orders_order { nil }
    receiver_name { 'MyString' }
    shipping_address { 'MyText' }
  end
end
