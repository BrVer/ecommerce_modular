# frozen_string_literal: true

module Inventory
  module UpdatePrice
    class Action
      include ::Callable

      def initialize(product, new_price:)
        @product = product
        @new_price = new_price
      end

      def call
        product.update!(price: new_price).tap do |p|
          Publisher.broadcast('inventory.price_updated', p.attributes)
        end
      end

      private

      attr_reader :product, :new_price
    end
  end
end
