# frozen_string_literal: true

module Inventory
  module DetachReservedQuantity
    class Action
      include ::Callable

      def initialize(product, quantity_to_detach:)
        @product = product
        @quantity_to_detach = quantity_to_detach
      end

      def call
        product.update!(reserved_quantity: product.reserved_quantity - quantity_to_detach)
      end

      private

      attr_reader :product, :quantity_to_detach
    end
  end
end
