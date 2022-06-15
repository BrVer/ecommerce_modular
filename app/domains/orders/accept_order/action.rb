# frozen_string_literal: true

module Orders
  module AcceptOrder
    class Action
      # when inventory.reservation_success
      include ::Callable

      def initialize(order, reservations:)
        @order = order
        @reservations = reservations
      end

      def call
        ActiveRecord::Base.transaction do
          order.accept
          reservations.each(&method(:mark_order_line_reserved))
          order.save!
        end
        Publisher.broadcast('order_accepted', OrderPresenter.new(order).attributes)
        order
      end

      private

      def mark_order_line_reserved(reservation)
        find_order_line(reservation).update!(price_at_submit: reservation[:price], reserved: true)
      end

      attr_reader :order, :reservations

      def order_lines
        @order_lines ||= order.order_lines
      end

      def find_order_line(reservation)
        order_lines.detect { |order_line| order_line.product_id == reservation[:product_id] }
      end
    end
  end
end
