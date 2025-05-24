class UserOrdersSerializer
  def self.create_serialized_hash(user:, orders:)
    user_hash = user.serializable_hash(only: %i[user_id name])
    
    user_hash['orders'] = orders.sort_by(&:order_id)
                                .map{ |order| OrderSerializer.create_serialized_hash(order)}
    user_hash
  end 
end