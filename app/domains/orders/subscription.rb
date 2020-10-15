# frozen_string_literal: true

module Orders
  class Subscription < ::Subscription
    private

    def inventory_reservation_success(payload)
      Orders::AcceptOrder::Action.call(payload[:order_id])
    end

    def inventory_reservation_failure(payload)
      Orders::CancelOrder::Action.call(payload[:order_id])
    end
  end
end
