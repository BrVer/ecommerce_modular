# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :state, String, null: false
    field :shipping_info, Types::ShippingInfoType
    field :contact_info, Types::ContactInfoType
    field :order_lines, [Types::OrderLineType], null: false

    def shipping_info
      dataloader.with(Sources::ActiveRecordObject, Orders::ShippingInfo, by_integer_field: :order_id).load(object.id)
    end

    def contact_info
      dataloader.with(Sources::ActiveRecordObject, Orders::ContactInfo, by_integer_field: :order_id).load(object.id)
    end

    def order_lines
      dataloader
        .with(Sources::ActiveRecordObject, Orders::OrderLine, by_integer_field: :order_id, multiple: true)
        .load(object.id)
    end
  end
end
