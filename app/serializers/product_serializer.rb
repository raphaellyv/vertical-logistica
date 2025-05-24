class ProductSerializer
  def self.to_serialized_hash(product)
    product.serializable_hash(only: [:product_id, :value] )
  end
end