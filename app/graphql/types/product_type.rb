# frozen_string_literal: true

module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :current_price, Integer, null: false
    field :available_quantity, Integer, null: false
  end
end
