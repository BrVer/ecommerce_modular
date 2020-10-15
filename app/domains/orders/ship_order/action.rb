# frozen_string_literal: true

module Orders
  module ShipOrder
    class Action
      include ::Callable

      def initialize(order_id)
        @order_id = order_id
      end

      def call
        order.ship
        order.save!
        Publisher.broadcast('orders.order_shipped', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order_id

      def order
        @order ||= ::Orders::Order.find(order_id)
      end
    end
  end
end
