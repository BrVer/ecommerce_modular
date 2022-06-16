# frozen_string_literal: true

module Payments
  module Publisher
    module_function

    def broadcast(event, payload = {}, partition_key: nil)
      ::Publisher.broadcast('payments', event, payload: payload, partition_key: partition_key)
    end
  end
end
