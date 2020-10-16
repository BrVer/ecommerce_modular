# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO: remove
  class << self
    def prepare_db
      [Orders::ApplicationRecord, Inventory::ApplicationRecord, Payments::ApplicationRecord].each do |model|
        truncate_database(model.connection)
      end

      p1 = Inventory::RegisterProduct::Action.call(name: 'p1', price: 12, available_quantity: 100)
      p2 = Inventory::RegisterProduct::Action.call(name: 'p2', price: 23, available_quantity: 100)
      _p3 = Inventory::RegisterProduct::Action.call(name: 'p3', price: 34, available_quantity: 100)

      order1 = Orders::PlaceOrder::Action.call(
        [{ quantity: 2, product_id: p1.id }, { quantity: 1, product_id: p2.id }]
      )
      order2 = Orders::PlaceOrder::Action.call(
        [{ quantity: 1, product_id: p1.id }, { quantity: 999, product_id: p2.id }]
      )

      Orders::ProvideContactInfo::Action.call(order1.id, phone: '+375441111111', email: 'email1@gmail.com')
      Orders::ProvideShippingInfo::Action.call(order1.id, shipping_address: 'address 1', receiver_name: 'receiver 1')

      Orders::ProvideContactInfo::Action.call(order2.id, phone: '+375442222222', email: 'email2@gmail.com')
      Orders::ProvideShippingInfo::Action.call(order2.id, shipping_address: 'address 2', receiver_name: 'receiver 2')
    end

    def truncate_database(connection)
      connection.execute('SET FOREIGN_KEY_CHECKS = 0;')
      connection.tables.each do |table|
        next if %w[ar_internal_metadata schema_migrations].include? table

        connection.truncate(table)
      end
      connection.execute('SET FOREIGN_KEY_CHECKS = 1;')
    end
  end
end
