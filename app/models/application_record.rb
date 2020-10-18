# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO: remove
  class << self
    def prepare_db
      [::Orders::ApplicationRecord, ::Inventory::ApplicationRecord, ::Payments::ApplicationRecord].each do |model|
        truncate_database(model.connection)
      end

      p1 = ::Inventory::RegisterProduct::Action.call(name: 'p1', price: 12, available_quantity: 100)
      p2 = ::Inventory::RegisterProduct::Action.call(name: 'p2', price: 23, available_quantity: 100)
      _p3 = ::Inventory::RegisterProduct::Action.call(name: 'p3', price: 34, available_quantity: 100)

      moderate_request = [{ product_id: p1.id, quantity: 2 }, { product_id: p2.id, quantity: 1 }]
      greedy_request = [{ product_id: p1.id, quantity: 1 }, { product_id: p2.id, quantity: 999 }]

      _order1_placed = ::Orders::PlaceOrder::Action.call(moderate_request)

      _order2_denied = submit_order(greedy_request)

      _order3_placed = prepare_order(moderate_request)

      _order4_payment_failed = submit_order(moderate_request)

      order5_ready_for_shipment = submit_order(moderate_request)
      authorize_order_payment(order5_ready_for_shipment)

      order6_shipment_cancelled = submit_order(moderate_request)
      authorize_order_payment(order6_shipment_cancelled, authorization_expires_in: 5.seconds)

      order7_shipment_failed = submit_order(moderate_request)
      authorize_order_payment(order7_shipment_failed)
      ::Orders::FailOrderShipment::Action.call(order7_shipment_failed.id)

      order8_shipped = submit_order(moderate_request)
      authorize_order_payment(order8_shipped)
      ::Orders::ShipOrder::Action.call(order8_shipped.id)
    end

    def submit_3rd_order
      ::Orders::SubmitOrder::Action.call(3)
    end

    def run_cron_jobs
      Payments::Workers::CheckAbandonedPayments.new.perform
      Payments::Workers::ExpireAuthorizations.new.perform
    end

    def submit_order(params)
      order = prepare_order(params)
      ::Orders::SubmitOrder::Action.call(order.id)
      order.reload
    end

    def prepare_order(params)
      order = ::Orders::PlaceOrder::Action.call(params)
      provide_info(order.id)
      order
    end

    def authorize_order_payment(order, authorization_expires_in: 5.days)
      ::Payments::AuthorizePayment::Action.call(payment(order).id,
                                                transaction_identifier: "tx_#{order.id}",
                                                authorization_expires_at: Time.current + authorization_expires_in)
    end

    def provide_info(order_id)
      ::Orders::ProvideContactInfo::Action.call(order_id,
                                              phone: "+37544#{rand(10000000).to_s}",
                                              email: "email#{order_id}@gmail.com")
      ::Orders::ProvideShippingInfo::Action.call(order_id,
                                               shipping_address: "address #{order_id}",
                                               receiver_name: "receiver #{order_id}")
    end

    def payment(order)
      ::Payments::CreditCardPayment.find_by(order_id: order.id)
    end

    def truncate_database(connection)
      connection.execute('SET FOREIGN_KEY_CHECKS = 0;')
      connection.tables.each do |table|
        next if %w[ar_internal_metadata schema_migrations].include? table

        connection.truncate(table)
      end
      connection.execute('SET FOREIGN_KEY_CHECKS = 1;')
    end
  end
end
