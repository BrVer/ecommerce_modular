# frozen_string_literal: true

module Orders
  module PlaceOrder
    class Action
      include ::Callable

      def initialize(order_lines_params)
        @order_lines_params = order_lines_params
      end

      def call
        Order.create!(state: :placed, order_lines_attributes: order_lines_params).tap do |order|
          Publisher.broadcast('orders.order_placed', OrderPresenter.new(order).attributes)
        end
      end

      private

      attr_reader :order_lines_params
    end
  end
end
