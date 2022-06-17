# frozen_string_literal: true

class UserOrders
  QUERY_STRING = <<~HEREDOC
    query userOrders($userId: ID!) {
      orders(userId: $userId) {
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

  def initialize(user_id)
    @user_id = user_id
  end

  def get
    EcommerceModularSchema.execute(QUERY_STRING, variables: { 'userId' => user_id }).to_h
  end

  private

  attr_reader :user_id
end
