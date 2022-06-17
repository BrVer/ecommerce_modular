# frozen_string_literal: true

module Payments
  module CreatePayment
    class Action
      include ::Callable

      def initialize(order)
        @order = order
      end

      def call
        create_payment!.tap do |payment|
          Publisher.broadcast('payment_created', payment.attributes)
        end
      end

      private

      attr_reader :order

      def create_payment!
        ::Payments::CreditCardPayment.create!(order_id: order[:id], user_id: order[:user_id],
                                              amount: calculate_amount, state: 'created')
      end

      def calculate_amount
        order[:order_lines].inject(0) { |sum, order_line| sum + (order_line[:price_at_submit] * order_line[:quantity]) }
      end
    end
  end
end
