# frozen_string_literal: true

module Inventory
  module ReserveProductQuantity
    class Action
      include ::Callable

      def initialize(product, quantity_to_reserve:)
        @product = product
        @quantity_to_reserve = quantity_to_reserve
      end

      def call
        product.update!(
          available_quantity: product.available_quantity - quantity_to_reserve,
          reserved_quantity: product.reserved_quantity + quantity_to_reserve
        )
      end

      private

      attr_reader :product, :quantity_to_reserve
    end
  end
end
