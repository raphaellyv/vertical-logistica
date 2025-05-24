class UserOrdersSerializer
  def self.to_serialized_hash(user)
    user_hash = user.serializable_hash(only: %i[user_id name])
    orders = user.orders.order(:order_id)

    user_hash['orders'] = orders.map{ |order| OrderSerializer.to_serialized_hash(order)}
    user_hash
  end
end