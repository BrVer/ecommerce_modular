# frozen_string_literal: true

module Orders
  module FailOrderShipment
    class Action
      include ::Callable

      def initialize(order_id)
        @order_id = order_id
      end

      def call
        order.fail_shipment
        order.save!
        Publisher.broadcast('order_shipment_failed', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order_id

      def order
        @order ||= Order.find(order_id)
      end
    end
  end
end
