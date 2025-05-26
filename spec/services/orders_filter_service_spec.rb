require 'rails_helper'

describe 'OrdersFilterService' do
  context '.filter_orders' do
    it 'filters orders by start and end_date' do
      user1 = User.create!(user_id: 44, name: 'Zarelli')
      user2 = User.create!(user_id: 12, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 3457, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 1234, date: Date.new(2022, 12, 01))
      order4 = Order.create!(user: user2, order_id: 34, date: Date.new(2021, 12, 01))

      product1 = Product.create!(product_id: 111, value: 512.24)
      product2 = Product.create!(product_id: 111, value: 256.24)
      product3 = Product.create!(product_id: 122, value: 256.24)
      product4 = Product.create!(product_id: 122, value: 512.24)

      ProductItem.create!(product: product1, order: order1)
      ProductItem.create!(product: product2, order: order2)
      ProductItem.create!(product: product3, order: order3)
      ProductItem.create!(product: product4, order: order4)

      filtered_orders = OrdersFilterService.filter_orders({ start_date: '2021-11-10', end_date: '2023-01-01' })

      expect(filtered_orders).to eq [order1, order3, order4]
    end

    it 'filters orders by order_id' do
      user1 = User.create!(user_id: 1, name: 'Zarelli')
      user2 = User.create!(user_id: 2, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 1234, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 3457, date: Date.new(2022, 12, 01))

      product1 = Product.create!(product_id: 111, value: 512.24)
      product2 = Product.create!(product_id: 122, value: 512.24)
      product3 = Product.create!(product_id: 111, value: 256.24)
      product4 = Product.create!(product_id: 122, value: 256.24)

      ProductItem.create!(product: product1, order: order1)
      ProductItem.create!(product: product2, order: order1)
      ProductItem.create!(product: product3, order: order2)
      ProductItem.create!(product: product4, order: order3)

      filtered_orders = OrdersFilterService.filter_orders({ order_id: 345 })

      expect(filtered_orders).to eq [order2]
    end

    it 'returns an empty hash if no orders are found' do
      user1 = User.create!(user_id: 1, name: 'Zarelli')
      user2 = User.create!(user_id: 2, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 1234, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 3457, date: Date.new(2022, 12, 01))

      product1 = Product.create!(product_id: 111, value: 512.24)
      product2 = Product.create!(product_id: 122, value: 512.24)
      product3 = Product.create!(product_id: 111, value: 256.24)
      product4 = Product.create!(product_id: 122, value: 256.24)

      ProductItem.create!(product: product1, order: order1)
      ProductItem.create!(product: product2, order: order1)
      ProductItem.create!(product: product3, order: order2)
      ProductItem.create!(product: product4, order: order3)

      filtered_orders = OrdersFilterService.filter_orders({ order_id: 4 })

      expect(filtered_orders).to eq []
    end
  end
end