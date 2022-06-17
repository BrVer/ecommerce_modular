# frozen_string_literal: true

def register_product(name:, price:, available_quantity: 100)
  ::Inventory::RegisterProduct::Action.call(name: name, price: price, available_quantity: available_quantity)
end

def place_order(user_id, params)
  ::Orders::PlaceOrder::Action.call(user_id, params)
end

def provide_info(order)
  ::Orders::ProvideContactInfo::Action.call(order.id,
                                            phone: "+37544#{rand(10_000_000)}",
                                            email: "email#{order.id}@gmail.com")
  ::Orders::ProvideShippingInfo::Action.call(order.id,
                                             shipping_address: "address #{order.id}",
                                             receiver_name: "receiver #{order.id}")
  order
end

def prepare_order(user_id, params)
  order = place_order(user_id, params)
  provide_info(order)
end

def submit_order(order)
  ::Orders::SubmitOrder::Action.call(order.id)
end

def fail_shipment(order)
  ::Orders::FailOrderShipment::Action.call(order.id)
end

def ship_order(order)
  ::Orders::ShipOrder::Action.call(order.id)
end

def authorize_order_payment(order, authorization_expires_in: 5.days)
  ::Payments::AuthorizePayment::Action.call(find_payment(order).id,
                                            transaction_identifier: "tx_#{order.id}",
                                            authorization_expires_at: Time.current + authorization_expires_in)
end

def find_payment(order)
  ::Payments::CreditCardPayment.find_by(order_id: order.id)
end
