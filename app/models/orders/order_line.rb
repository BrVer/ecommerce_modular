class Orders::OrderLine < ApplicationRecord
  belongs_to :order, foreign_key: :orders_order_id
  belongs_to :inventory_product, class_name: '::Inventory::Product'
end
