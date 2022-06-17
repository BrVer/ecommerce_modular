# frozen_string_literal: true

module Support
  class Data
    class << self
      def seed_db # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        truncate_data

        User.establish_connection # a hack to fix a bug after truncation
        user1 = User.create(email: 'user1@gmail.com', password: 'password1')
        user2 = User.create(email: 'user2@gmail.com', password: 'password2')

        p1 = ::Inventory::RegisterProduct::Action.call(name: 'p1', price: 12, available_quantity: 100)
        p2 = ::Inventory::RegisterProduct::Action.call(name: 'p2', price: 23, available_quantity: 100)
        _p3 = ::Inventory::RegisterProduct::Action.call(name: 'p3', price: 34, available_quantity: 100)

        moderate_request = [{ product_id: p1.id, quantity: 2 }, { product_id: p2.id, quantity: 1 }]
        greedy_request = [{ product_id: p1.id, quantity: 1 }, { product_id: p2.id, quantity: 999 }]

        _order1_placed = ::Orders::PlaceOrder::Action.call(user1.id, moderate_request)

        _order2_denied = submit_order(user2.id, greedy_request)

        _order3_placed = prepare_order(user2.id, moderate_request)

        _order4_payment_failed = submit_order(user2.id, moderate_request)

        order5_ready_for_shipment = submit_order(user2.id, moderate_request)
        ensure_appropriate_state
        authorize_order_payment(order5_ready_for_shipment) # TODO: check that user_id == order.user_id

        order6_shipment_cancelled = submit_order(user2.id, moderate_request)
        ensure_appropriate_state
        # TODO: check that user_id == order.user_id
        authorize_order_payment(order6_shipment_cancelled, authorization_expires_in: 5.seconds)

        order7_shipment_failed = submit_order(user2.id, moderate_request)
        ensure_appropriate_state
        authorize_order_payment(order7_shipment_failed) # TODO: check that user_id == order.user_id
        ensure_appropriate_state
        ::Orders::FailOrderShipment::Action.call(order7_shipment_failed.id)

        order8_shipped = submit_order(user2.id, moderate_request)
        ensure_appropriate_state
        authorize_order_payment(order8_shipped) # TODO: check that user_id == order.user_id
        ensure_appropriate_state
        ::Orders::ShipOrder::Action.call(order8_shipped.id)
      end

      def submit_3rd_order
        ::Orders::SubmitOrder::Action.call(3) # TODO: check that user_id == order.user_id
      end

      def run_cron_jobs
        Payments::Workers::CheckAbandonedPayments.new.perform
        Payments::Workers::ExpireAuthorizations.new.perform
      end

      private

      def submit_order(user_id, params)
        order = prepare_order(user_id, params)
        ::Orders::SubmitOrder::Action.call(order.id) # TODO: check that user_id == order.user_id
        order.reload # TODO: wait a second
      end

      def prepare_order(user_id, params)
        order = ::Orders::PlaceOrder::Action.call(user_id, params)
        provide_info(order.id) # TODO: check that user_id == order.user_id
        order
      end

      def authorize_order_payment(order, authorization_expires_in: 5.days)
        ::Payments::AuthorizePayment::Action.call(payment(order).id,
                                                  transaction_identifier: "tx_#{order.id}",
                                                  authorization_expires_at: Time.current + authorization_expires_in)
      end

      def provide_info(order_id)
        ::Orders::ProvideContactInfo::Action.call(order_id,
                                                  phone: "+37544#{rand(10_000_000)}",
                                                  email: "email#{order_id}@gmail.com")
        ::Orders::ProvideShippingInfo::Action.call(order_id,
                                                   shipping_address: "address #{order_id}",
                                                   receiver_name: "receiver #{order_id}")
      end

      def ensure_appropriate_state
        sleep(5) if ENV.fetch('COMMUNICATION_BACKEND') == 'kafka'
      end

      def payment(order)
        ::Payments::CreditCardPayment.find_by(order_id: order.id)
      end

      def truncate_data
        ActiveRecord::Tasks::DatabaseTasks.truncate_all
      end
    end
  end
end
