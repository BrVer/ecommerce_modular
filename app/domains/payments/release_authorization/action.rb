# frozen_string_literal: true

module Payments
  module ReleaseAuthorization
    class Action
      include ::Callable

      def initialize(payment)
        @payment = payment
      end

      def call
        # send a request to external system
        payment.release_authorization
        payment.save!
        Publisher.broadcast('authorization_released', payment.attributes)
        payment
      end

      private

      attr_reader :payment
    end
  end
end
