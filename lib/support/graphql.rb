# frozen_string_literal: true

module Support
  module Graphql
    QUERY_STRING = <<~HEREDOC
      {
        orders(userId: 2) {
          id
          state
          shippingInfo {
            receiverName
            shippingAddress
          }
          contactInfo {
            email
            phone
          }
          orderLines {
            id
            product {
              id
              name
            }
            quantity
            reserved
            priceAtSubmit
          }
        }
      }
    HEREDOC

    module_function

    def check
      EcommerceModularSchema.execute(QUERY_STRING).to_h
    end
  end
end
