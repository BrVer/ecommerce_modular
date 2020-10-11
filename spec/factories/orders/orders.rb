FactoryBot.define do
  factory :orders_order, class: 'Orders::Order' do
    status { "MyString" }
  end
end
