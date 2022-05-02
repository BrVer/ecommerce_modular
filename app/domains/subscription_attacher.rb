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
      orders.order_shipment_cancelled
      orders.order_shipment_failed
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
    SUBSCRIPTIONS.each do |subscription_name, messages|
      subscription = subscription_name.to_s.constantize
      messages.each { subscription.attach_to(_1) }
    end
  end
end
