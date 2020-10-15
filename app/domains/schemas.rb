# frozen_string_literal: true

module Schemas
  Product = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:order_lines).array(:hash) do
      required(:product_id).filled(:integer)
      required(:quantity).filled(:integer, gteq?: 1)
    end
  end
end
