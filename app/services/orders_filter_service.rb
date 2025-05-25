class OrdersFilterService
  def self.filter_orders(filters)
    orders = Order.all

    filters.each do |key, value|
      orders =  orders.public_send("filter_by_#{key}", value) if value.present?
    end

    orders
  end
end