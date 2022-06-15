# frozen_string_literal: true

module Payments
  module Publisher
    module_function

    def broadcast(event, payload = {})
      ::Publisher.broadcast('payments', event, payload)
    end
  end
end
