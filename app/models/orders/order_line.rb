# frozen_string_literal: true

module Orders
  class OrderLine < ApplicationRecord
    belongs_to :order

    validates :quantity, presence: true, numericality: { greater_than: 0 }
  end
end
