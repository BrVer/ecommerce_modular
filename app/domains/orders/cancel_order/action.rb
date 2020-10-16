# frozen_string_literal: true

module Orders
  module CancelOrder
    class Action
      include ::Callable

      def initialize(order_id, reason:)
        @order_id = order_id
        @reason = reason
      end

      def call
        order.cancel
        order.cancel_reason = reason
        order.save!
        Publisher.broadcast('orders.order_cancelled', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order_id, :reason

      def order
        @order ||= Order.find(order_id)
      end
    end
  end
end
