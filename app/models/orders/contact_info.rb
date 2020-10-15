# frozen_string_literal: true

module Orders
  class ContactInfo < ApplicationRecord
    belongs_to :order, foreign_key: :orders_order_id, inverse_of: :contact_info

    validates :email, presence: true
  end
end
