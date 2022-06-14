# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :state, String, null: false
    field :shipping_info, Types::ShippingInfoType
    field :contact_info, Types::ContactInfoType
    field :order_lines, [Types::OrderLineType], null: false
  end
end
