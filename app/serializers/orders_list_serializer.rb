class OrdersListSerializer
  def self.create_serialized_hash_array(filters: {})
    orders = filters.values.any? ? OrdersFilterService.filter_orders(filters) : Order.all
    
    grouped_orders = orders.order(:order_id)
                           .group_by(&:user_id)
      
    user_ids = grouped_orders.keys

    User.where(user_id: user_ids)
        .order(:user_id)
        .map{ |user| UserOrdersSerializer.create_serialized_hash(user: user, orders: grouped_orders[user.user_id]) }
        .select{ |user| user['orders'].any? }
  end
end