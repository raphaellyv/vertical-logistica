class ProductSerializer
  def self.create_serialized_hash(product)
    product.serializable_hash(only: [:product_id, :value] )
  end
end