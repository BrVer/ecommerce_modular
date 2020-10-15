# frozen_string_literal: true

module Orders
  class OrderLine < ApplicationRecord
    belongs_to :order,
               foreign_key: :orders_order_id,
               class_name: 'Orders::Order',
               inverse_of: :order_lines

    validates :quantity, presence: true, numericality: { greater_than: 0 }
  end
end
