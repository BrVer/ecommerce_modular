# frozen_string_literal: true

module Orders
  module MarkOrderForShipment
    class Action
      include ::Callable

      def initialize(order_id)
        @order_id = order_id
      end

      def call
        order.mark_for_shipment
        order.save!
        Publisher.broadcast('orders.marked_for_shipment', OrderPresenter.new(order).attributes)
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
