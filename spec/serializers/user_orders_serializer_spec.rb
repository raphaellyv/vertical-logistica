require 'rails_helper'

describe 'UserOrdersSerializer' do
  context '.create_serialized_hash' do
    context 'all orders' do
      it 'returns a formatted hash of the user orders' do
        user1 = User.create!(user_id: 9, name: 'Medeiros')
        user2 = User.create!(user_id: 5, name: 'Zarelli')

        order1 = Order.create!(user: user1, order_id: 455, date: Date.new(2021, 12, 01))
        order2 = Order.create!(user: user1, order_id: 259, date: Date.new(2020, 12, 01))
        order3 = Order.create!(user: user2, order_id: 155, date: Date.new(2022, 12, 01))

        Product.create!(product_id: 122, value: 499.87, order: order1)
        Product.create!(product_id: 111, value: 590.04, order: order1)
        Product.create!(product_id: 111, value: 256.24, order: order2)
        Product.create!(product_id: 122, value: 256.24, order: order3)

        serialized_user_orders = UserOrdersSerializer.create_serialized_hash(user: user1, orders: user1.orders)

        expect(serialized_user_orders.keys).to eq ['user_id', 'name', 'orders']
        expect(serialized_user_orders['user_id']).to eq 9
        expect(serialized_user_orders['name']).to eq 'Medeiros'
        expect(serialized_user_orders['orders'].length).to eq 2
        
        expect(serialized_user_orders['orders'][0].keys).to eq ['order_id', 'date','total',  'products']
        expect(serialized_user_orders['orders'][0]['order_id']).to eq 259
        expect(serialized_user_orders['orders'][0]['date']).to eq Date.new(2020, 12, 01)
        expect(serialized_user_orders['orders'][0]['total']).to eq 256.24
        expect(serialized_user_orders['orders'][0]['products'].length).to eq 1

        expect(serialized_user_orders['orders'][1]['order_id']).to eq 455
        expect(serialized_user_orders['orders'][1]['date']).to eq Date.new(2021, 12, 01)
        expect(serialized_user_orders['orders'][1]['total']).to eq 1089.91
        expect(serialized_user_orders['orders'][1]['products'].length).to eq 2

        expect(serialized_user_orders['orders'][0]['products'][0].keys).to eq ['product_id', 'value']
        expect(serialized_user_orders['orders'][0]['products'][0]['product_id']).to eq 111
        expect(serialized_user_orders['orders'][0]['products'][0]['value']).to eq 256.24

        expect(serialized_user_orders['orders'][1]['products'][0]['product_id']).to eq 111
        expect(serialized_user_orders['orders'][1]['products'][0]['value']).to eq 590.04

        expect(serialized_user_orders['orders'][1]['products'][1]['product_id']).to eq 122
        expect(serialized_user_orders['orders'][1]['products'][1]['value']).to eq 499.87
      end
    end
  end
end