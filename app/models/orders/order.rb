# frozen_string_literal: true

module Orders
  class Order < ApplicationRecord
    CANCEL_REASONS = { expired: 'expired', payment_failed: 'payment_failed' }.freeze

    include AASM

    has_one :shipping_info, dependent: :destroy
    has_one :contact_info, dependent: :destroy
    has_many :order_lines, dependent: :destroy

    accepts_nested_attributes_for :order_lines

    has_paper_trail only: %i[state],
                    versions: { class_name: '::Orders::Version' }

    validates :cancel_reason, inclusion: { in: CANCEL_REASONS.values }, if: -> { cancelled? } # TODO: use form objects

    aasm column: :state do
      state :placed, initial: true
      state :submitted, :denied, :accepted, :cancelled, :ready_for_shipment, :shipment_cancelled, :shipped

      event :submit do
        transitions from: :placed, to: :submitted
      end
      event :deny do
        transitions from: :submitted, to: :denied
      end
      event :accept do
        transitions from: :submitted, to: :accepted
      end
      event :cancel do
        transitions from: :accepted, to: :cancelled
      end
      event :mark_for_shipment do
        transitions from: :accepted, to: :ready_for_shipment
      end
      event :cancel_shipment do
        transitions from: :ready_for_shipment, to: :shipment_cancelled
      end
      event :ship do
        transitions from: :ready_for_shipment, to: :shipped
      end
    end
  end
end
