class OrdersListSerializer
  def self.create_serialized_hash_array(filters: {})
    User.order(:user_id)
        .map{ |user| UserOrdersSerializer.create_serialized_hash(user:, filters:) }
        .select{ |user| user['orders'].any? }
  end
end