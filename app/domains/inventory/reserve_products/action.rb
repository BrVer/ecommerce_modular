# frozen_string_literal: true

module Inventory
  module ReserveProducts
    class Action
      include ::Callable

      def initialize(reservations:)
        @reservations = reservations
      end

      def call
        # TODO: aggregate array of { product_id: 123, price: 45 }
        ::Inventory::Product.transaction { reservations.each(&method(:process_reservation)) }
      end

      private

      attr_reader :reservations

      def process_reservation(reservation)
        product = products.detect { |p| p.id == reservation[:product_id] }
        product.lock!
        ReserveProductQuantity::Action.call(product, quantity_to_reserve: reservation[:quantity])
      end

      def products
        @products ||= ::Inventory::Product.where(
          id: reservations.map { |p| p[:product_id] } # rubocop:disable Rails/Pluck
        )
      end
    end
  end
end
