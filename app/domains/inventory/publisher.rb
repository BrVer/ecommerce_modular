# frozen_string_literal: true

module Inventory
  module Publisher
    module_function

    def broadcast(event, payload, partition_key: nil)
      ::Publisher.broadcast('inventory', event, payload: payload, partition_key: partition_key)
    end
  end
end
