# frozen_string_literal: true

module Inventory
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true

    connects_to database: { writing: :inventory,  reading: :inventory }
  end
end
