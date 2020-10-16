# frozen_string_literal: true

module Orders
  module DenyOrder
    class Action
      include ::Callable

      def initialize(order_id)
        @order_id = order_id
      end

      def call
        order.deny
        order.save!
        Publisher.broadcast('orders.order_denied', OrderPresenter.new(order).attributes)
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
