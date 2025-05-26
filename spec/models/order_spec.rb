require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'requires order_id' do
        order = Order.new(order_id: '')

        order.valid?

        expect(order.errors.include?(:order_id)).to be true
      end

      it 'requires date' do
        order = Order.new(date: '')

        order.valid?

        expect(order.errors.include?(:date)).to be true
      end
    end

    context 'uniqueness' do
      it 'requires order_id to be unique' do
        user = User.create!(user_id: 1, name: 'Souza')
        Order.create!(order_id: 1, date: Date.current, user:)
        order = Order.new(order_id: 1)

        order.valid?

        expect(order.errors.include?(:order_id)).to be true
      end
    end
  end

  describe '#calculate_total_value' do
    it 'calculates the total price of an order' do
      user1 = User.create!(user_id: 1, name: 'Joaquim')
      user2 = User.create!(user_id: 2, name: 'Pietro')

      order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
      order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user2)
      order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

      product1 = Product.create!(product_id: 1, value: 2.99)
      product2 = Product.create!(product_id: 2, value: 5.0)
      product3 = Product.create!(product_id: 3, value: 10.0)
      product4 = Product.create!(product_id: 3, value: 20.0)

      ProductItem.create!(product: product1, order: order1)
      ProductItem.create!(product: product2, order: order1)
      ProductItem.create!(product: product3, order: order2)
      ProductItem.create!(product: product4, order: order3)

      expect(order1.calculate_total_value).to eq 7.99
    end
  end

  describe 'scope' do
    context '.filter_by_start_date' do
      it 'filters orders by date including the start date' do
        user1 = User.create!(user_id: 1, name: 'Joaquim')
        user2 = User.create!(user_id: 2, name: 'Pietro')

        order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
        order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user2)
        order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

        filtered_orders = Order.filter_by_start_date('2020-02-02'.to_date)

        expect(filtered_orders.length).to eq 2
        expect(filtered_orders.first).to eq order2
        expect(filtered_orders.last).to eq order3
      end

      it 'returns an empty array if no orders are found' do
        user1 = User.create!(user_id: 1, name: 'Joaquim')
        user2 = User.create!(user_id: 2, name: 'Pietro')

        order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
        order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user2)
        order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

        filtered_orders = Order.filter_by_end_date('2019-02-02'.to_date)

        expect(filtered_orders).to eq []
      end
    end

    context '.filter_by_end_date' do
      it 'filters orders by date including the end date' do
        user1 = User.create!(user_id: 1, name: 'Joaquim')
        user2 = User.create!(user_id: 2, name: 'Pietro')

        order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
        order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user2)
        order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

        filtered_orders = Order.filter_by_end_date('2020-02-02')

        expect(filtered_orders.length).to eq 2
        expect(filtered_orders.first).to eq order1
        expect(filtered_orders.last).to eq order2
      end

      it 'returns an empty array if no orders are found' do
        user1 = User.create!(user_id: 1, name: 'Joaquim')
        user2 = User.create!(user_id: 2, name: 'Pietro')

        order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
        order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user2)
        order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

        filtered_orders = Order.filter_by_end_date('2019-02-02')

        expect(filtered_orders).to eq []
      end
    end

    context '.filter_by_order_id' do
      it 'filters orders by order_id' do
        user1 = User.create!(user_id: 1, name: 'Joaquim')
        user2 = User.create!(user_id: 2, name: 'Pietro')

        order1 = Order.create!(order_id: 123, date: Date.new(2020, 1, 1), user: user1)
        order2 = Order.create!(order_id: 12, date: Date.new(2020, 2, 2), user: user2)
        order3 = Order.create!(order_id: 23, date: Date.new(2020, 3, 3), user: user2)

        filtered_orders = Order.filter_by_order_id('12')

        expect(filtered_orders.length).to eq 1
        expect(filtered_orders.first).to eq order2
      end

      it 'returns an empty array if no orders are found' do
        user1 = User.create!(user_id: 1, name: 'Joaquim')
        user2 = User.create!(user_id: 2, name: 'Pietro')

        order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
        order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user2)
        order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

        filtered_orders = Order.filter_by_order_id('12')

        expect(filtered_orders).to eq []
      end
    end
  end

  describe 'primary_key' do
    it 'has order_id as the primary_key' do
      expect(Order.primary_key).to eq 'order_id'
    end
  end
end
