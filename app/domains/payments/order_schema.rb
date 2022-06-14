# frozen_string_literal: true

module Payments
  OrderSchema = Dry::Schema.Params do
    required(:id).filled(:integer)
    required(:user_id).filled(:integer)
    required(:order_lines).array(:hash) do
      required(:price_at_submit).filled(:integer)
      required(:quantity).filled(:integer, gteq?: 1)
    end
  end
end
