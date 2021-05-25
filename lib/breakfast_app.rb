
class BreakfastApp
  def self.call(price_list_json, orders_json)
    return [{}] if orders_json.empty?

    orders = JSON.load(orders_json)
    price_list = JSON.load(price_list_json)
    orders.map do  |order|
      total_items_price = calculate_order_total(price_list, order['items'])
      if total_items_price <= order['money']
        {
          'name': order['name'],
          'change': order['money'] - total_items_price,
          'status': 'success'
        }
      else
        {
          'name': order['name'],
          'change': order['money'],
          'status': 'fail',
          'error': 'Insufficient Money.'
        }
      end
    end.to_json
  end

  private

  def self.calculate_order_total(price_list, items)
    items.inject(0) do |sum, item|
      item_price = price_list.find { |price_item| price_item['id'] == item }['price']
      sum + item_price
    end
  end
end
