# frozen_string_literal: true

module Orders
  module AcceptOrder
    class Action
      include ::Callable

      def initialize(order_id, reservations:)
        @order_id = order_id
        @reservations = reservations
      end

      def call
        ActiveRecord::Base.transaction do
          order.accept
          reservations.each(&method(:set_order_line_price))
          order.save!
          # TODO: schedule a Sidekiq job to cancel the order with reason 'expired' in 20 min
        end
        Publisher.broadcast('orders.order_accepted', OrderPresenter.new(order).attributes)
        order
      end

      private

      def set_order_line_price(reservation)
        find_order_line(reservation).update!(price_at_submit: reservation[:price])
      end

      attr_reader :order_id, :reservations

      def order
        @order ||= Order.find(order_id)
      end

      def order_lines
        @order_lines ||= order.order_lines
      end

      def find_order_line(reservation)
        order_lines.detect { |order_line| order_line.product_id == reservation[:product_id] }
      end
    end
  end
end
