FactoryBot.define do
  factory :orders_contact_info, class: 'Orders::ContactInfo' do
    orders_order { nil }
    phone { 'MyString' }
    email { 'MyString' }
  end
end
