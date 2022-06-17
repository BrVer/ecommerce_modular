# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'order accepted' do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:product1) { register_product(name: 'product1', price: 12) }
  let(:product2) { register_product(name: 'product2', price: 23) }
  let!(:product3) { register_product(name: 'product3', price: 34) }
  let(:order) do
    place_order(1, [{ product_id: product1.id, quantity: 2 }, { product_id: product2.id, quantity: 1 }])
  end
  let(:phone) { '+375447633556' }
  let(:email) { 'email1@gmail.com' }
  let(:shipping_address) { 'address 1' }
  let(:receiver_name) { 'receiver 1' }

  before do
    ::Orders::ProvideContactInfo::Action.call(order.id, phone: phone, email: email)
    ::Orders::ProvideShippingInfo::Action.call(order.id,
                                               shipping_address: shipping_address, receiver_name: receiver_name)
    submit_order(order)
  end

  it 'works properly', :aggregate_failures do
    expect(order.reload).to be_accepted
    expect(order.contact_info).to have_attributes(phone: phone, email: email)
    expect(order.shipping_info).to have_attributes(shipping_address: shipping_address, receiver_name: receiver_name)
    payment = find_payment(order)
    expect(payment).to have_attributes(state: 'created', amount: 47)
    expect(product1.reload).to have_attributes(available_quantity: 98, reserved_quantity: 2)
    expect(product2.reload).to have_attributes(available_quantity: 99, reserved_quantity: 1)
    expect(product3.reload).to have_attributes(available_quantity: 100, reserved_quantity: 0)
  end
end
