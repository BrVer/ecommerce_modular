# frozen_string_literal: true

module Payments
  module Workers
    class CheckAbandonedPayments
      include Sidekiq::Worker

      def perform
        Payments::CreditCardPayment.transaction do
          abandoned_payments.lock.find_each { ::Payments::FailAuthorization::Action.call(_1) }
        end
      end

      private

      def abandoned_payments
        ::Payments::CreditCardPayment.where(state: :created).where(
          'created_at < ?', Time.zone.now - ::Payments::CreditCardPayment::PAYMENT_TIME
        )
      end
    end
  end
end
