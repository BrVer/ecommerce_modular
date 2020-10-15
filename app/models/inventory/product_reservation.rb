# frozen_string_literal: true

# TODO: use this abstraction
module Inventory
  class ProductReservation < Dry::Struct
    attribute :product_id,        Types::Integer
    attribute :reserved_quantity, Types::Integer
    attribute :price,             Types::Integer
  end
end
