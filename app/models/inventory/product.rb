# frozen_string_literal: true

module Inventory
  class Product < ApplicationRecord
    validates :name, :current_price, :available_quantity, presence: true
    validates :current_price, numericality: { greater_than: 0 }
    validates :available_quantity, numericality: { greater_than_or_equal_to: 0 }

    has_paper_trail only: %i[current_price available_quantity reserved_quantity],
                    versions: { class_name: '::Inventory::Version' }
  end
end
