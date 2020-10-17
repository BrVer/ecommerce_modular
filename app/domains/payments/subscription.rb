# frozen_string_literal: true

module Payments
  class Subscription < ::Subscription
    private

    def orders_order_accepted(order)
      schema = ::Payments::OrderSchema.call(order)
      raise InvalidContract.new(schema.errors.to_h) unless schema.success?

      ::Payments::CreatePayment::Action.call(schema.to_h)
    end

    def orders_order_shipment_failed(order)
      ::Payments::ReleaseAuthorization::Action.call(find_payment_for_order(order))
    end

    def orders_order_shipped(order)
      ::Payments::CaptureAuthorization::Action.call(find_payment_for_order(order))
    end

    # ------- helper methods: -------#

    def find_payment_for_order(order)
      ::Payments::CreditCardPayment.find_by(order_id: order['id'])
    end
  end
end
