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
          Publisher.broadcast('payments.payment_created', payment.attributes)
        end
      end

      private

      attr_reader :order

      def create_payment!
        CreditCardPayment.create!(order_id: order[:id], amount: calculate_amount, state: 'created')
      end

      def calculate_amount
        order[:order_lines].inject(0) { |sum, order_line| sum + order_line[:price_at_submit] }
      end
    end
  end
end
