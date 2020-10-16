# frozen_string_literal: true

module Inventory
  class Subscription < ::Subscription
    private

    def orders_order_submitted(params)
      order = order_contract(params)
      ::Inventory::ReserveProducts::Action.call(order_id: order[:id], reservations: order[:order_lines])
    end

    def orders_order_cancelled(params)
      order = order_contract(params)
      ::Inventory::CancelReservations::Action.call(reservations: order[:order_lines])
    end

    def order_contract(order)
      schema = ::Inventory::OrderSchema.call(order)
      raise InvalidContract.new(schema.errors.to_h) unless schema.success?

      schema.to_h
    end
  end
end
