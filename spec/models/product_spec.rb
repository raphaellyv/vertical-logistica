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

    context 'uniqueness' do
      it 'requires product_id to be unique for each order' do
        user = User.create!(user_id: 1, name: 'Aldo')
        order1 = Order.create!(order_id: 1, date: '2022-03-15'.to_date, user:)
        order2 = Order.create!(order_id: 2, date: '2023-03-15'.to_date, user:)

        Product.create!(product_id: 1, order: order1, value: 2.33)
        product1 = Product.new(product_id: 1, order: order1, value: 2.33)
        product2 = Product.new(product_id: 1, order: order2, value: 2.33)

        product1.valid?
        product2.valid?

        expect(product1.errors.include?(:product_id)).to be true
        expect(product2.errors.include?(:product_id)).to be false
      end
    end
  end
end
