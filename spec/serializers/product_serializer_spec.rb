require 'rails_helper'

describe 'ProductSerializer' do
  context '.create_serialized_hash' do
    it 'returns a formatted product hash' do
      user1 = User.create!(user_id: 9, name: 'Medeiros')
      order1 = Order.create!(user: user1, order_id: 455, date: Date.new(2021, 12, 01))

      product1 = Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 512.24, order: order1)

      serialized_product = ProductSerializer.create_serialized_hash(product1)

      expect(serialized_product.keys).to eq ['product_id', 'value']
      expect(serialized_product['product_id']).to eq 122
      expect(serialized_product['value']).to eq 512.24
    end
  end
end