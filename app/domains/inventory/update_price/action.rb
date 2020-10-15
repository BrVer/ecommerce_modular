# frozen_string_literal: true

module Inventory
  module UpdatePrice
    class Action
      include ::Callable

      def initialize(product_id, new_price:)
        @product_id = product_id
        @new_price = new_price
      end

      def call
        product.update!(price: new_price).tap do |p|
          Publisher.broadcast('inventory.price_updated', p.attributes)
        end
      end

      private

      attr_reader :product_id, :new_price

      def product
        @product ||= ::Inventory::Product.find(product_id)
      end
    end
  end
end
