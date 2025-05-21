require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'requires product_id' do
        product = Product.new(product_id: '')

        product.valid?

        expect(product.errors.include?(:product_id)).to be true
      end

      it 'requires value' do
        product = Product.new(value: '')

        product.valid?

        expect(product.errors.include?(:value)).to be true
      end
    end

    context 'comparison' do
      it 'requires total to be greater than 0' do
        product1 = Product.new(value: 0.00)
        product2 = Product.new(value: 0.01)

        product1.valid?
        product2.valid?

        expect(product1.errors.include?(:value)).to be true
        expect(product2.errors.include?(:value)).to be false
      end
    end
  end

  describe 'on create' do
    it 'updates product order total' do
      user1 = User.create!(user_id: 1, name: 'Joaquim')
      user2 = User.create!(user_id: 2, name: 'Pietro')

      order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
      order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user1)
      order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

      product1 = Product.new(product_id: 1, value: 2.99, order: order1)
      product2 = Product.new(product_id: 2, value: 5.0, order: order1)
      product3 = Product.new(product_id: 3, value: 10.0, order: order2)
      product4 = Product.new(product_id: 3, value: 20.0, order: order3)

      expect(order1.total).to eq 0

      product1.save!
      product2.save!
      product3.save!
      product4.save!

      expect(order1.total).to eq 7.99
    end
  end

  describe 'on update' do
    it 'updates product order total' do
      user1 = User.create!(user_id: 1, name: 'Joaquim')
      user2 = User.create!(user_id: 2, name: 'Pietro')

      order1 = Order.create!(order_id: 1, date: Date.new(2020, 1, 1), user: user1)
      order2 = Order.create!(order_id: 2, date: Date.new(2020, 2, 2), user: user1)
      order3 = Order.create!(order_id: 3, date: Date.new(2020, 3, 3), user: user2)

      product1 = Product.create!(product_id: 1, value: 2.99, order: order1)
      product2 = Product.create!(product_id: 2, value: 5.0, order: order1)
      product3 = Product.create!(product_id: 3, value: 10.0, order: order2)
      product4 = Product.create!(product_id: 3, value: 20.0, order: order3)

      expect(order1.total).to eq 7.99

      product1.update!(value: 3.99)

      expect(order1.total).to eq 8.99
    end
  end
end
