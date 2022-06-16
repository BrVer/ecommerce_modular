# frozen_string_literal: true

module Orders
  module Publisher
    module_function

    def broadcast(event, payload, partition_key: nil)
      ::Publisher.broadcast('orders', event, payload: payload, partition_key: partition_key)
    end
  end
end
