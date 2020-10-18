# frozen_string_literal: true

module Payments
  module Workers
    class ExpireAuthorizations
      include Sidekiq::Worker

      def perform
        Payments::CreditCardPayment.transaction do
          payments_with_expired_authorization.lock.find_each { ::Payments::ExpireAuthorization::Action.call(_1) }
        end
      end

      private

      def payments_with_expired_authorization
        Payments::CreditCardPayment.where(state: :authorized).where('authorization_expires_at < ?', Time.now)
      end
    end
  end
end
