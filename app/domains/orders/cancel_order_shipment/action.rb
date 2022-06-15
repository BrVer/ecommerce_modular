# frozen_string_literal: true

module Orders
  module CancelOrderShipment
    # when payments.authorization_expired
    class Action
      include ::Callable

      def initialize(order)
        @order = order
      end

      def call
        order.cancel_shipment
        order.save!
        Publisher.broadcast('order_shipment_cancelled', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order
    end
  end
end
