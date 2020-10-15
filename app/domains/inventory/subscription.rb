# frozen_string_literal: true

module Inventory
  class Subscription < ::Subscription
    private

    def orders_order_submitted(order)
      schema = Schemas::Product.call(order)
      raise InvalidContract.new(schema.errors.to_h) unless schema.success? # rubocop:disable Style/RaiseArgs

      reserve_products_for_order(schema.to_h)
    end

    def reserve_products_for_order(order)
      ReserveProducts::Action.call(reservations: order[:order_lines])
      Publisher.broadcast('inventory.reservation_success', order_id: order[:id])
    rescue StandardError
      Publisher.broadcast('inventory.reservation_failure', order_id: order[:id])
    end
  end
end
