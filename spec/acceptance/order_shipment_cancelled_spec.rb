# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "order shipment cancelled" do
  let!(:product1) { register_product(name: 'product1', price: 12) }
  let!(:product2) { register_product(name: 'product2', price: 23) }
  let!(:product3) { register_product(name: 'product3', price: 34) }
  let!(:order) do
    prepare_order([{ product_id: product1.id, quantity: 2 }, { product_id: product2.id, quantity: 1 }])
  end

  before do
    submit_order(order)
    authorize_order_payment(order)
    travel_to(Time.now + 6.days) { Payments::Workers::ExpireAuthorizations.new.perform }
  end

  it 'works properly', :aggregate_failures do
    expect(order.reload).to be_shipment_cancelled
    payment = find_payment(order)
    expect(payment).to be_authorization_expired
    expect(product1.reload).to have_attributes(available_quantity: 100, reserved_quantity: 0)
    expect(product2.reload).to have_attributes(available_quantity: 100, reserved_quantity: 0)
    expect(product3.reload).to have_attributes(available_quantity: 100, reserved_quantity: 0)
  end
end
