require 'rails_helper'

describe 'OrdersFilterService' do
  context '.filter_orders' do
    it 'filters orders by start and end_date and groups them by user_id' do
      user1 = User.create!(user_id: 44, name: 'Zarelli')
      user2 = User.create!(user_id: 12, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 3457, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 1234, date: Date.new(2022, 12, 01))
      order4 = Order.create!(user: user2, order_id: 34, date: Date.new(2021, 12, 01))

      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)
      Product.create!(product_id: 122, value: 512.24, order: order4)

      grouped_orders = OrdersFilterService.filter_orders({ start_date: '2021-11-10', end_date: '2023-01-01' })

      expect(grouped_orders.class).to eq Hash
      expect(grouped_orders.length).to eq 2
      expect(grouped_orders.keys).to eq [user2.id, user1.id]
      expect(grouped_orders[user2.id]).to eq [order4]
      expect(grouped_orders[user1.id]).to eq [order3, order1]
    end

    it 'filters orders by order_id' do
      user1 = User.create!(user_id: 1, name: 'Zarelli')
      user2 = User.create!(user_id: 2, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 1234, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 3457, date: Date.new(2022, 12, 01))

      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)

      grouped_orders = OrdersFilterService.filter_orders({ order_id: 345 })

      expect(grouped_orders.length).to eq 1
      expect(grouped_orders.keys).to eq [user2.id]
      expect(grouped_orders[user2.id]).to eq [order2]
    end

    it 'returns an empty hash if no orders are found' do
      user1 = User.create!(user_id: 1, name: 'Zarelli')
      user2 = User.create!(user_id: 2, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 1234, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 3457, date: Date.new(2022, 12, 01))

      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)

      grouped_orders = OrdersFilterService.filter_orders({ order_id: 4 })

      expect(grouped_orders.length).to eq 0
      expect(grouped_orders).to eq Hash.new
    end
  end
end