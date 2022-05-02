# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Tasks::DatabaseTasks.truncate_all

p1 = Inventory::RegisterProduct::Action.call(name: 'p1', price: 12, available_quantity: 100)
p2 = Inventory::RegisterProduct::Action.call(name: 'p2', price: 23, available_quantity: 100)
_p3 = Inventory::RegisterProduct::Action.call(name: 'p3', price: 34, available_quantity: 100)

order_1 = Orders::PlaceOrder::Action.call([{ quantity: 2, product_id: p1.id },{ quantity: 1, product_id: p2.id }])
order_2 = Orders::PlaceOrder::Action.call([{ quantity: 1, product_id: p1.id }, { quantity: 999, product_id: p2.id }])

Orders::ProvideContactInfo::Action.call(order_1.id, phone: '+375441111111', email: 'email1@gmail.com')
Orders::ProvideShippingInfo::Action.call(order_1.id, shipping_address: 'address 1', receiver_name: 'receiver 1')

Orders::ProvideContactInfo::Action.call(order_2.id, phone: '+375442222222', email: 'email2@gmail.com')
Orders::ProvideShippingInfo::Action.call(order_2.id, shipping_address: 'address 2', receiver_name: 'receiver 2')

# Orders::SubmitOrder::Action.call(order_1.id)
# Orders::SubmitOrder::Action.call(order_2.id)
