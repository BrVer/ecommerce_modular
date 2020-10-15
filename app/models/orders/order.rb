# frozen_string_literal: true

module Orders
  class Order < ApplicationRecord
    include AASM

    has_one :shipping_info
    has_one :contact_info
    has_many :order_lines

    accepts_nested_attributes_for :order_lines

    has_paper_trail only: %i[state],
                    versions: { class_name: '::Orders::Version' }

    aasm column: :state do
      state :placed, initial: true
      state :submitted, :accepted, :cancelled, :ready_for_shipment, :shipped

      event :submit do
        transitions from: :placed, to: :submitted
      end
      event :accept do
        transitions from: :submitted, to: :accepted
      end
      event :cancel do
        transitions from: %i[submitted accepted], to: :cancelled
      end
      event :mark_ready_for_shipment do
        transitions from: :accepted, to: :ready_for_shipment
      end
      event :ship do
        transitions from: :ready_for_shipment, to: :shipped
      end
    end
  end
end
