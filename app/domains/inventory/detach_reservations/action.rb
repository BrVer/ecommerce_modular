# frozen_string_literal: true

module Inventory
  module DetachReservations
    class Action
      include ::Callable

      def initialize(reservations:)
        @reservations = reservations
      end

      def call
        Product.transaction { reservations.each(&method(:detach_reservation)) }
      end

      private

      attr_reader :reservations

      def detach_reservation(reservation)
        product = products.detect { |p| p.id == reservation[:product_id] }
        product.lock!
        DetachReservedQuantity::Action.call(product, quantity_to_detach: reservation[:quantity])
      end

      def products
        @products ||= Product.where(
          id: reservations.map { |p| p[:product_id] } # rubocop:disable Rails/Pluck
        )
      end
    end
  end
end
