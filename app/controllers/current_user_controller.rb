class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    query_string = "{
 orders(userId: #{current_user.id}) {
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
}"
    current_user_orders = EcommerceModularSchema.execute(query_string).to_h['data']['orders']
    user_attributes = UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    render json: user_attributes.merge(orders: current_user_orders), status: :ok
  end
end
