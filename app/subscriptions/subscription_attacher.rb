# frozen_string_literal: true

class SubscriptionAttacher

  # EVENTS = %w[orders.order_placed
  #             orders.shipping_info_provided
  #             orders.contact_info_provided
  #             orders.order_submitted
  #             orders.order_cancelled
  #             orders.order_shipped
  #             fulfillment.order_accepted
  #             fulfillment.order_rejected
  #             inventory.product_registered
  #             inventory.product_quantity_set
  #             payments.payment_created
  #             payments.payment_failed
  #             payments.payment_succeeded
  #             payments.authorisation_failed
  #             payments.authorisation_succeeded
  #             payments.capture_failed
  #             payments.capture_succeeded
  #          ].freeze

  SUBSCRIPTIONS = {
    # 'Payments::Subscription': [
    #   :'orders.order_accepted'
    # ],
    'Inventory::Subscription': [
      :'orders.order_submitted'
    ],
    'Orders::Subscription': [
      :'inventory.reservation_success',
      :'inventory.reservation_failure'
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

