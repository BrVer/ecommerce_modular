# frozen_string_literal: true

module Orders
  class ShippingInfo < ApplicationRecord
    belongs_to :order

    validates :receiver_name, :shipping_address, presence: true
  end
end
