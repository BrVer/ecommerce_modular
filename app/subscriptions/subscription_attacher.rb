# frozen_string_literal: true

class SubscriptionAttacher
  SUBSCRIPTIONS = {
    'Payments::Subscription': %i[
      orders.order_accepted
      orders.order_shipment_failed
      orders.order_shipped
    ],
    'Inventory::Subscription': %i[
      orders.order_submitted
      orders.order_cancelled
      orders.orders_order_shipment_cancelled
      orders.orders_order_shipment_failed
      orders.order_shipped
    ],
    'Orders::Subscription': %i[
      inventory.reservation_success
      inventory.reservation_failure
      payments.authorization_failed
      payments.authorization_expired
      payments.payment_authorized
    ]
  }.freeze

  def attach_subscriptions
    SUBSCRIPTIONS.each do |subscription, messages|
      attach(subscription.to_s.constantize, messages)
    end
  end

  private

  def attach(subscription, messages)
    messages.each { |message| subscription.attach_to(message) }
  end
end
