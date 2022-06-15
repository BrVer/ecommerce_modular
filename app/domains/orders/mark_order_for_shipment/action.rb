# frozen_string_literal: true

module Orders
  module MarkOrderForShipment
    class Action
      # when payments.payment_authorized
      include ::Callable

      def initialize(order)
        @order = order
      end

      def call
        order.mark_for_shipment
        order.save!
        Publisher.broadcast('marked_for_shipment', OrderPresenter.new(order).attributes)
        order
      end

      private

      attr_reader :order
    end
  end
end
