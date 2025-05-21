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
      order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user1)
      order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

      Product.create!(product_id: 1, value: 2.99, order: order1)
      Product.create!(product_id: 2, value: 5.0, order: order1)
      Product.create!(product_id: 3, value: 10.0, order: order2)
      Product.create!(product_id: 3, value: 20.0, order: order3)

      expect(order1.calculate_total_value).to eq 7.99
    end
  end
end
