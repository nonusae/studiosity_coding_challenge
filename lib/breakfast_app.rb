class ApplicationService
  def self.call(*args)
    new(*args).call
  end
end

class BreakfastApp < ApplicationService
  def initialize(price_list_json, orders_json)
    return [{}] if orders_json.empty?

    @orders = Orders.new(orders_json).orders
    @price_list = PriceList.new(price_list_json).price_list
  end

  def call
    changes.to_json
  end

  private

  def changes
    @orders.map do |order|
      order_total = calculate_order_total(order.items)
      Cashier.for(order, order_total).change
    end
  end

  def calculate_order_total(items)
    items.inject(0) do |sum, item|
      item_price = @price_list.find { |price_item| price_item.id == item }.price
      sum + item_price
    end
  end
end

class Cashier
  def self.for(order, order_total)
    order_total <= order.money ? SuccessOrder.new(order, order_total) : InsufficientMoneyOrder.new(order)
  end
end

class SuccessOrder
  def initialize(order, order_total)
    @order = order
    @order_total = order_total
  end

  def change
    {
      'name': @order.name,
      'change': @order.money - @order_total,
      'status': 'success'
    }
  end
end

class InsufficientMoneyOrder
  def initialize(order)
    @order = order
  end

  def change
    {
      'name': @order.name,
      'change': @order.money,
      'status': 'fail',
      'error': 'Insufficient Money.'
    }
  end
end

class Orders
  attr_reader :orders

  def initialize(orders_json)
    @orders = build_orders(orders_json)
  end

  private

  def build_orders(orders)
    loaded_orders = JSON.load(orders)
    loaded_orders.map { |order| OpenStruct.new(**order) }
  end
end

class PriceList
  attr_reader :price_list

  def initialize(price_list_json)
    @price_list = build_price_list(price_list_json)
  end

  private

  def build_price_list(price_list)
    loaded_price_list = JSON.load(price_list)
    loaded_price_list.map { |price| OpenStruct.new(**price) }
  end
end
