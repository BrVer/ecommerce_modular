# frozen_string_literal: true

module Orders
  module ProvideContactInfo
    class ContactInfoAlreadyExist < StandardError; end
    class InvalidOrderState < StandardError; end

    class Action
      include ::Callable

      def initialize(order_id, phone:, email:)
        @order_id = order_id
        @phone = phone
        @email = email
      end

      def call
        authorize_action
        create_contact_info!.tap do |_contact_info|
          Publisher.broadcast('contact_info_provided', OrderPresenter.new(order).attributes)
        end
      end

      private

      def authorize_action
        raise InvalidOrderState unless order.placed?
        raise ContactInfoAlreadyExist if order.contact_info&.persisted?
      end

      def create_contact_info!
        order.create_contact_info!(phone: phone, email: email)
      end

      attr_reader :order_id, :phone, :email

      def order
        @order ||= Order.find(order_id)
      end
    end
  end
end
