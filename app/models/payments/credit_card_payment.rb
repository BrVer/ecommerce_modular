# frozen_string_literal: true

module Payments
  class CreditCardPayment < ApplicationRecord
    validates :amount, :state, presence: true
    validates :amount, numericality: { greater_than: 0 }

    has_paper_trail only: %i[state],
                    versions: { class_name: '::Payments::Version' }
  end
end
