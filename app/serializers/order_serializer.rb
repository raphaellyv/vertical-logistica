class OrderSerializer
  def self.to_serialized_hash(order)
    order_hash = order.serializable_hash(only: %i[order_id date])
    products = order.products.order(:product_id)

    order_hash['total'] = order.calculate_total_value
    order_hash['products'] = products.map{ |product| ProductSerializer.to_serialized_hash(product) }
    order_hash
  end
end