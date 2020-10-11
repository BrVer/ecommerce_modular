class Orders::ContactInfo < ApplicationRecord
  belongs_to :order, foreign_key: :orders_order_id
end
