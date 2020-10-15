# frozen_string_literal: true

module Orders
  class ContactInfo < ApplicationRecord
    belongs_to :order

    validates :email, presence: true
  end
end
