# frozen_string_literal: true

module Orders
  module Publisher
    module_function

    def broadcast(event, payload = {})
      ::Publisher.broadcast('orders', event, payload)
    end
  end
end
