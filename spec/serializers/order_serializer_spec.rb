require 'rails_helper'

describe 'OrderSerializer' do
  context 'to_serialized_json' do
    it 'returns the serialized json' do
      user1 = User.create!(user_id: 9, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 455, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user1, order_id: 259, date: Date.new(2020, 12, 01))

      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)

      serialized_order = OrderSerializer.to_serialized_hash(order1)

      expect(serialized_order.keys).to eq ['order_id', 'date', 'total', 'products']
      expect(serialized_order['order_id']).to eq 455
      expect(serialized_order['date']).to eq Date.new(2021, 12, 01)
      expect(serialized_order['total']).to eq 1024.48
      
      expect(serialized_order['products'][0].keys).to eq ['product_id', 'value']
      expect(serialized_order['products'].length).to eq 2
      expect(serialized_order['products'][0]['product_id']).to eq 111
      expect(serialized_order['products'][1]['product_id']).to eq 122
      expect(serialized_order['products'][0]['value']).to eq 512.24
      expect(serialized_order['products'][1]['value']).to eq 512.24
    end
  end
end