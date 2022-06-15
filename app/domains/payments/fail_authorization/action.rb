# frozen_string_literal: true

module Payments
  module FailAuthorization
    class Action
      include ::Callable

      def initialize(payment)
        @payment = payment
      end

      def call
        payment.fail_authorization
        payment.save!
        Publisher.broadcast('authorization_failed', payment.attributes)
        payment
      end

      private

      attr_reader :payment
    end
  end
end
