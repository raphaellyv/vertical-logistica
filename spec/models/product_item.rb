require 'rails_helper'

RSpec.describe ProductItem, type: :model do
  describe '#valid?' do
    context 'uniqueness' do
      it 'requires order_id to be unique for each product_id' do
        user = User.create!(user_id: 1, name: 'João')
        order = Order.create!(order_id: 1, user: user, date: Date.new(2020, 2, 2))
        product = Product.create!(product_id: 111, value: 2.39)

        ProductItem.create!(product: product, order: order)
        product_item = ProductItem.new(product: product, order: order)

        product_item.valid?

        expect(product_item.errors.include?(:product_id)).to be true
      end
    end
  end
end