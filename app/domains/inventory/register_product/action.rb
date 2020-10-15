# frozen_string_literal: true

module Inventory
  module RegisterProduct
    class ProductAlreadyExist < StandardError; end

    class Action
      include ::Callable

      def initialize(name:, price:, available_quantity:)
        @name = name
        @price = price
        @available_quantity = available_quantity
      end

      def call
        raise ProductAlreadyExist if Product.exists?(name: name) # TODO: try to save, catch exception, throw our one

        create_product!.tap do |product|
          Publisher.broadcast('inventory.product_registered', product.attributes)
        end
      end

      private

      attr_reader :name, :price, :available_quantity

      def create_product!
        Product.create!(name: name, current_price: price, available_quantity: available_quantity)
      end
    end
  end
end
