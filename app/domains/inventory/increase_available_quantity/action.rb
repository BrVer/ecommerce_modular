# frozen_string_literal: true

module Inventory
  module IncreaseAvailableQuantity
    class Action
      include ::Callable

      def initialize(product, quantity_to_add:)
        @product = product
        @quantity_to_add = quantity_to_add
      end

      def call
        product.update!(available_quantity: product.available_quantity + quantity_to_add)
      end

      private

      attr_reader :product, :quantity_to_add
    end
  end
end
