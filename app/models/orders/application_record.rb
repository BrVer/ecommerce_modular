# frozen_string_literal: true

module Orders
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true

    connects_to database: { writing: :orders,  reading: :orders }
  end
end
