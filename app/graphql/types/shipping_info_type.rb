# frozen_string_literal: true

module Types
  class ShippingInfoType < Types::BaseObject
    field :receiver_name, String, null: false
    field :shipping_address, String, null: false
  end
end
