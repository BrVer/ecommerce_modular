# frozen_string_literal: true

module Payments
  module AuthorizePayment
    class Action
      include ::Callable

      def initialize(payment_id, transaction_identifier:, authorization_expires_at:)
        @payment_id = payment_id
        @transaction_identifier = transaction_identifier
        @authorization_expires_at = authorization_expires_at
      end

      def call
        payment.authorize
        payment.transaction_identifier = transaction_identifier
        payment.authorization_expires_at = authorization_expires_at
        payment.save!
        Publisher.broadcast('payments.payment_authorized', payment.attributes)
        payment
      end

      private

      attr_reader :payment_id, :transaction_identifier, :authorization_expires_at

      def payment
        @payment ||= ::Payments::CreditCardPayment.find(payment_id)
      end
    end
  end
end
