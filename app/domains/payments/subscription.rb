# frozen_string_literal: true

module Payments
  class Subscription < ::Subscription
    private

    def orders_order_accepted(order)
      schema = ::Payments::OrderSchema.call(order)
      raise InvalidContract.new(schema.errors.to_h) unless schema.success?

      ::Payments::CreatePayment::Action.call(schema.to_h)
    end

    def orders_order_cancelled(order)
      payment = CreditCardPayment.find(order_id: order['id'])
      ::Payments::ReleaseAuthorization::Action.call(payment)
    end

    def orders_order_shipped(order)
      payment = CreditCardPayment.find(order_id: order['id'])
      ::Payments::CaptureAuthorization::Action.call(payment)
    end
  end
end
