# frozen_string_literal: true

module Inventory
  module ReleaseReservedQuantity
    class Action
      include ::Callable

      def initialize(product, quantity_to_release:)
        @product = product
        @quantity_to_release = quantity_to_release
      end

      def call
        product.update!(
          available_quantity: product.available_quantity + quantity_to_reserve,
          reserved_quantity: product.reserved_quantity - quantity_to_release
        )
      end

      private

      attr_reader :product, :quantity_to_release
    end
  end
end
