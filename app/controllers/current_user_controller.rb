class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    current_user_orders = UserOrders.new(current_user.id).get['data']['orders']
    user_attributes = UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    render json: user_attributes.merge(orders: current_user_orders), status: :ok
  end
end
