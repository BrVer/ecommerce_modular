# frozen_string_literal: true

module Orders
  module SubmitOrder
    class Action
      include ::Callable

      def initialize(order_id)
        @order_id = order_id
      end

      def call
        order.submit
        order.save!
        Publisher.broadcast('orders.order_submitted', OrderPresenter.new(order).attributes)
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
