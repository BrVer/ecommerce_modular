# frozen_string_literal: true

module Payments
  module CaptureAuthorization
    class Action
      include ::Callable

      def initialize(payment)
        @payment = payment
      end

      def call
        # send a request to external system
        payment.capture_authorization
        payment.save!
        Publisher.broadcast('payments.payment_paid', payment.attributes)
        payment
      end

      private

      attr_reader :payment
    end
  end
end
