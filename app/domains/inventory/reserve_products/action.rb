# frozen_string_literal: true

module Inventory
  module ReserveProducts
    class Action
      include ::Callable

      def initialize(order_id:, reservations:)
        @order_id = order_id
        @reservations = reservations
      end

      def call
        # TODO: problem is, partition_key = order_id doesn't make sense as in other inventory events we use product.id
        # solution is to have 2 topics: inventory_reservations && inventory_products
        if try_reserve_products # TODO: stupid, replace with RabbitMQ
          Publisher.broadcast('reservation_success',
                              { 'order_id' => order_id, 'reservations' => reservations },
                              partition_key: order_id)
        else
          Publisher.broadcast('reservation_failure', { 'order_id' => order_id }, partition_key: order_id)
        end
      end

      private

      def try_reserve_products
        Product.transaction { reservations.each(&method(:process_reservation)) }
        true
      rescue StandardError
        false
      end

      attr_reader :reservations, :order_id

      def process_reservation(reservation)
        product = products.detect { |p| p.id == reservation[:product_id] }
        product.lock!
        ReserveProductQuantity::Action.call(product, quantity_to_reserve: reservation[:quantity])
        reservation[:price] = product.current_price
      end

      def products
        @products ||= Product.where(id: reservations.map { |p| p[:product_id] }) # rubocop:disable Rails/Pluck
      end
    end
  end
end
