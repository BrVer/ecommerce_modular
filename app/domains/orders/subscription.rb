# frozen_string_literal: true

module Orders
  class Subscription < ::Subscription
    private

    def inventory_reservation_failure(payload)
      ::Orders::DenyOrder::Action.call(order(payload[:order_id]))
    end

    def inventory_reservation_success(payload)
      # TODO: check reservations contract
      ::Orders::AcceptOrder::Action.call(order(payload[:order_id]), reservations: payload[:reservations])
    end

    def payments_authorization_failed(payment)
      ::Orders::CancelOrder::Action.call(order(payment['order_id']))
    end

    def payments_payment_authorized(payment)
      ::Orders::MarkOrderForShipment::Action.call(order(payment['order_id']))
    end

    def payments_authorization_expired(payment)
      ::Orders::CancelOrderShipment::Action.call(order(payment['order_id']))
    end

    # ------- helper methods: -------#

    def order(order_id)
      ::Orders::Order.find(order_id)
    end
  end
end
