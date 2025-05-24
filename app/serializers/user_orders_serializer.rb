class UserOrdersSerializer
  def self.create_serialized_hash(user:, filters: {})
    @filters = filters
    @user_orders = user.orders.order(:order_id)
    user_hash = user.serializable_hash(only: %i[user_id name])
    
    filter_user_orders if filters.values.any?
    
    user_hash['orders'] = @user_orders.map{ |order| OrderSerializer.create_serialized_hash(order)}
    user_hash
  end 

  private

  def self.filter_user_orders
    @filters.each do |key, value|
      @user_orders =  @user_orders.public_send("filter_by_#{key}", value) if value.present?
    end
  end
end