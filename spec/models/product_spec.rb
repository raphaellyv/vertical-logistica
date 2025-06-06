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

    context 'uniqueness' do
      it 'requires value to be unique for each product_id' do
        Product.create!(product_id: 1, value: 2.33)
        product1 = Product.new(product_id: 1, value: 2.33)
        product2 = Product.new(product_id: 1, value: 3.33)
        product3 = Product.new(product_id: 2, value: 2.33)

        product1.valid?
        product2.valid?
        product3.valid?

        expect(product1.errors.include?(:value)).to be true
        expect(product2.errors.include?(:value)).to be false
        expect(product3.errors.include?(:value)).to be false
      end
    end
  end
end
