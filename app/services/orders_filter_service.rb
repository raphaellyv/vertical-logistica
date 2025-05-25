class OrdersFilterService
  def self.filter_orders(filters)
    orders = Order.all

    if filters.values.any?
      filters.each do |key, value|
        orders =  orders.public_send("filter_by_#{key}", value) if value.present?
      end
    end

    orders.order(:order_id)
          .group_by(&:user_id)
  end
end