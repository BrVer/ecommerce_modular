Attempt to rewrite https://github.com/aniarosner/payments-ddd in a modular way

# Tables:

## Product
- name
- current_price
- available_quantity

## Order
- has_many :order_lines
- has_one :shipping_info
- has_one :contact_info
- has_one :payment
- status

## OrderLine
- order_id
- product_id
- quantity
- price_at_submit

## ShippingInfo
- order_id
- receiver_name
- shipping_address

# ContactInfo
- order_id
- phone
- email

## CreditCardPayment
- order_id
- currency ??
- amount
- transaction_identifier
- status