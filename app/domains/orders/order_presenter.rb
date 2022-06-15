# frozen_string_literal: true

module Orders
  class OrderPresenter
    def initialize(order)
      @order = order
    end

    def attributes
      order.attributes.merge('order_lines' => order.order_lines.map(&:attributes))
    end

    private

    attr_reader :order
  end
end
