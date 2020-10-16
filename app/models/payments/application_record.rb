# frozen_string_literal: true

module Payments
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true

    connects_to database: { writing: :payments, reading: :payments }
  end
end
