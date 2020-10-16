# frozen_string_literal: true

module Payments
  module AuthorizeCreditCard
    class Action
      include ::Callable

      def initialize(payment_id)
        @payment_id = payment_id
      end

      def call
        payment.authorize
        payment.save!
        Publisher.broadcast('payments.payment_authorized', payment.attributes)
        payment
      end

      private

      attr_reader :payment_id

      def payment
        @payment ||= CreditCardPayment.find(payment_id)
      end
    end
  end
end
