# frozen_string_literal: true

module Orders
  class Subscription < ::Subscription
    private

    def inventory_reservation_success(payload)
      # TODO: check reservations contract
      ::Orders::AcceptOrder::Action.call(payload[:order_id], reservations: payload[:reservations])
    end

    def inventory_reservation_failure(payload)
      ::Orders::DenyOrder::Action.call(payload[:order_id])
    end

    def payments_authorization_failed(payment)
      ::Orders::CancelOrder::Action.call(payment['order_id'], reason: Order::CANCEL_REASONS[:payment_failed])
    end

    def payments_authorization_expired(payment)
      ::Orders::CancelOrder::Action.call(payment['order_id'])
    end

    def payments_payment_authorized(payment)
      ::Orders::MarkOrderForShipment::Action.call(payment['order_id'])
    end
  end
end
