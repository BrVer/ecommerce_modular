# frozen_string_literal: true

module Payments
  class CreditCardPayment < ApplicationRecord
    include AASM

    validates :amount, :state, presence: true
    validates :amount, numericality: { greater_than: 0 }

    has_paper_trail only: %i[state],
                    versions: { class_name: '::Payments::Version' }

    aasm column: :state do
      state :created, initial: true
      state :authorized, :authorization_failed, :authorization_expired, :authorization_released, :paid

      event :authorize do
        transitions from: :created, to: :authorized
      end
      event :fail_authorization do
        transitions from: :created, to: :authorization_failed
      end
      event :expire_authorization do
        transitions from: :authorized, to: :authorization_expired
      end
      event :release_authorization do
        transitions from: :authorized, to: :authorization_released
      end
      event :capture_authorization do
        transitions from: :authorized, to: :paid
      end
    end
  end
end
