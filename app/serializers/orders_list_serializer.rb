class OrdersListSerializer
  def self.create_serialized_hash_array(filters: {}, page_param: 0)
    orders = Order.all

    if filters.values.any?
      filters.each do |key, value|
        orders =  orders.public_send("filter_by_#{key}", value) if value.present?
      end
    end

    grouped_orders = orders.order(:order_id).group_by(&:user_id)
    filtered_user_ids = grouped_orders.keys

    page = page_param.to_i
    per_page = 5
    offset = (page - 1) * per_page
    
    filtered_user_ids = filtered_user_ids.slice(offset, per_page) if page > 0

    User.where(user_id: filtered_user_ids)
        .order(:user_id)
        .map{ |user| UserOrdersSerializer.create_serialized_hash(user: user, orders: grouped_orders[user.user_id]) }
        .select{ |user| user['orders'].any? }
  end
end