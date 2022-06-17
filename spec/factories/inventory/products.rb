FactoryBot.define do
  factory :inventory_product, class: 'Inventory::Product' do
    name { 'MyString' }
    current_price { 1 }
    available_quantity { 1 }
  end
end
