# frozen_string_literal: true

module Inventory
  module Publisher
    module_function

    def broadcast(event, payload = {})
      ::Publisher.broadcast('inventory', event, payload)
    end
  end
end
