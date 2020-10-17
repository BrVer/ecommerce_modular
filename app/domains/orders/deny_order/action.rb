# frozen_string_literal: true

module Orders
  module DenyOrder
    class Action
      # when inventory.reservation_failure
      include ::Callable

      def initialize(order)
        @order = order
      end

      def call
        order.deny
        order.save!
        Publisher.broadcast('orders.order_denied', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order
    end
  end
end
