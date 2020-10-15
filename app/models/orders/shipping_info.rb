# frozen_string_literal: true

module Orders
  class ShippingInfo < ApplicationRecord
    belongs_to :order, foreign_key: :orders_order_id, inverse_of: :shipping_info

    validates :receiver_name, :shipping_address, presence: true
  end
end
