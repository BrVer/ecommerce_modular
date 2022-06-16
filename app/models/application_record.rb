# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO: remove
  class << self
    def test_graphql
      query_string = "{
 orders(userId: 2) {
    id
    state
    shippingInfo {
      receiverName
      shippingAddress
    }
    contactInfo {
      email
      phone
    }
    orderLines {
      id
      product {
        id
        name
      }
      quantity
      reserved
      priceAtSubmit
    }
  }
}"
      EcommerceModularSchema.execute(query_string).to_h['data']['orders']
    end

    def prepare_db
      truncate_data

      User.establish_connection # hack to fix a bug after truncation
      user_1 = User.create(email: 'user1@gmail.com', password: 'password1')
      user_2 = User.create(email: 'user2@gmail.com', password: 'password2')

      p1 = ::Inventory::RegisterProduct::Action.call(name: 'p1', price: 12, available_quantity: 100)
      p2 = ::Inventory::RegisterProduct::Action.call(name: 'p2', price: 23, available_quantity: 100)
      _p3 = ::Inventory::RegisterProduct::Action.call(name: 'p3', price: 34, available_quantity: 100)

      moderate_request = [{ product_id: p1.id, quantity: 2 }, { product_id: p2.id, quantity: 1 }]
      greedy_request = [{ product_id: p1.id, quantity: 1 }, { product_id: p2.id, quantity: 999 }]

      _order1_placed = ::Orders::PlaceOrder::Action.call(user_1.id, moderate_request)

      _order2_denied = submit_order(user_2.id, greedy_request)

      _order3_placed = prepare_order(user_2.id, moderate_request)

      _order4_payment_failed = submit_order(user_2.id, moderate_request)

      order5_ready_for_shipment = submit_order(user_2.id, moderate_request)
      authorize_order_payment(order5_ready_for_shipment) # TODO: check that user_id == order.user_id

      order6_shipment_cancelled = submit_order(user_2.id, moderate_request)
      authorize_order_payment(order6_shipment_cancelled, authorization_expires_in: 5.seconds) # TODO: check that user_id == order.user_id

      order7_shipment_failed = submit_order(user_2.id, moderate_request)
      authorize_order_payment(order7_shipment_failed) # TODO: check that user_id == order.user_id
      ::Orders::FailOrderShipment::Action.call(order7_shipment_failed.id)

      order8_shipped = submit_order(user_2.id, moderate_request)
      authorize_order_payment(order8_shipped) # TODO: check that user_id == order.user_id
      ::Orders::ShipOrder::Action.call(order8_shipped.id)
    end

    def submit_3rd_order
      ::Orders::SubmitOrder::Action.call(3) # TODO: check that user_id == order.user_id
    end

    def run_cron_jobs
      Payments::Workers::CheckAbandonedPayments.new.perform
      Payments::Workers::ExpireAuthorizations.new.perform
    end

    def submit_order(user_id, params)
      order = prepare_order(user_id, params)
      ::Orders::SubmitOrder::Action.call(order.id) # TODO: check that user_id == order.user_id
      order.reload
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
                                                phone: "+37544#{rand(10000000).to_s}",
                                                email: "email#{order_id}@gmail.com")
      ::Orders::ProvideShippingInfo::Action.call(order_id,
                                                 shipping_address: "address #{order_id}",
                                                 receiver_name: "receiver #{order_id}")
    end

    def kafka_topics
      %w(orders payments inventory) # TODO: constant
    end

    def kafka_client
      @kafka_client ||= Kafka.new(['kafka://127.0.0.1:9092'])
    end

    def reset_kafka_topics
      delete_kafka_topics
      create_kafka_topics
    end

    def delete_kafka_topics
      kafka_topics.each { kafka_client.delete_topic(_1) }
    end

    def create_kafka_topics
      kafka_topics.each do |topic_name|
        kafka_client.create_topic(topic_name,
                                  num_partitions: 3, replication_factor: 1, config: { 'retention.ms' => 2_419_200_000 })
      end
    end

    def payment(order)
      ::Payments::CreditCardPayment.find_by(order_id: order.id)
    end

    def truncate_data
      ActiveRecord::Tasks::DatabaseTasks.truncate_all
    end
  end
end
