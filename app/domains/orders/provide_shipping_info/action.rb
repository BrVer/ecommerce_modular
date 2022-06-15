# frozen_string_literal: true

module Orders
  module ProvideShippingInfo
    class ShippingInfoAlreadyExist < StandardError; end
    class InvalidOrderState < StandardError; end

    class Action
      include ::Callable

      def initialize(order_id, shipping_address:, receiver_name:)
        @order_id = order_id
        @shipping_address = shipping_address
        @receiver_name = receiver_name
      end

      def call
        authorize_action
        create_shipping_info!.tap do |_shipping_info|
          Publisher.broadcast('shipping_info_provided', OrderPresenter.new(order).attributes)
        end
      end

      private

      def authorize_action
        raise InvalidOrderState unless order.placed?
        raise ShippingInfoAlreadyExist if order.shipping_info&.persisted?
      end

      def create_shipping_info!
        order.create_shipping_info!(shipping_address: shipping_address, receiver_name: receiver_name)
      end

      attr_reader :order_id, :shipping_address, :receiver_name

      def order
        @order ||= Order.find(order_id)
      end
    end
  end
end
