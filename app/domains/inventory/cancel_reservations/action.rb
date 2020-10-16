# frozen_string_literal: true

module Inventory
  module CancelReservations
    class Action
      include ::Callable

      def initialize(reservations:)
        @reservations = reservations
      end

      def call
        Product.transaction { reservations.each(&method(:cancel_reservation)) }
      end

      private

      attr_reader :reservations

      def cancel_reservation(reservation)
        product = products.detect { |p| p.id == reservation[:product_id] }
        product.lock!
        ReleaseReservedQuantity::Action.call(product, quantity_to_release: reservation[:quantity])
      end

      def products
        @products ||= Product.where(
          id: reservations.map { |p| p[:product_id] } # rubocop:disable Rails/Pluck
        )
      end
    end
  end
end
