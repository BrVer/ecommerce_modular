# frozen_string_literal: true

module Types
  class OrderLineType < Types::BaseObject
    field :id, ID, null: false
    field :product, ProductType, null: false
    field :quantity, Integer, null: false
    field :reserved, Boolean, null: false
    field :price_at_submit, Integer

    def product
      dataloader.with(Sources::ActiveRecordObject, Inventory::Product).load(object.product_id)
    end
  end
end
