# frozen_string_literal: true

module Payments
  module ExpireAuthorization
    class Action
      include ::Callable

      def initialize(payment)
        @payment = payment
      end

      def call
        payment.expire_authorization
        payment.save!
        Publisher.broadcast('payments.authorization_expired', payment.attributes)
        payment
      end

      private

      attr_reader :payment
    end
  end
end
