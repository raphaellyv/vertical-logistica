require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'requires order_id' do
        order = Order.new(order_id: '')

        order.valid?

        expect(order.errors.include?(:order_id)).to be true
      end

      it 'requires total' do
        order = Order.new(total: '')

        order.valid?

        expect(order.errors.include?(:total)).to be true
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
        Order.create!(order_id: 1, total: 20.2, date: Date.current, user:)
        order = Order.new(order_id: 1)

        order.valid?

        expect(order.errors.include?(:order_id)).to be true
      end
    end

    context 'comparison' do
      it 'requires total to be greater than or equal to 0' do
        order1 = Order.new(total: 0)
        order2 = Order.new(total: 0.01)
        order3 = Order.new(total: -0.01)

        order1.valid?
        order2.valid?
        order3.valid?

        expect(order1.errors.include?(:total)).to be false
        expect(order2.errors.include?(:total)).to be false
        expect(order3.errors.include?(:total)).to be true
      end
    end
  end
end
