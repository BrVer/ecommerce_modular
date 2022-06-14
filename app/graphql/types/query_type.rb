module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :order, OrderType, description: "Find an order by ID" do
      argument :id, ID
    end

    field :orders, [OrderType], description: "Find orders of a specific user" do
      argument :user_id, ID
    end

    def orders(user_id:)
      Orders::Order.where(user_id: user_id)
    end

    def order(id:)
      Orders::Order.find(id)
    end
  end
end
