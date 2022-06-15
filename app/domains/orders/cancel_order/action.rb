# frozen_string_literal: true

module Orders
  module CancelOrder
    class Action
      # when payments.authorization_failed
      include ::Callable

      def initialize(order)
        @order = order
      end

      def call
        order.cancel
        order.save!
        Publisher.broadcast('order_cancelled', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order
    end
  end
end
