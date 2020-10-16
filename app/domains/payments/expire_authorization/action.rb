# frozen_string_literal: true

module Payments
  module ExpireAuthorization
    class Action
      include ::Callable

      def initialize(payment_id)
        @payment_id = payment_id
      end

      def call
        payment.expire_authorization
        payment.save!
        Publisher.broadcast('payments.authorization_expired', payment.attributes)
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
