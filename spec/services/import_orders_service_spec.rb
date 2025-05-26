require 'rails_helper'

describe 'ImportOrdersService' do
  context '.import_from_txt_file' do
    it 'imports new orders from file' do
      ImportOrdersService.import_from_txt_file('./spec/support/data_1.txt')

      expect(Product.count).to eq 19
      expect(ProductItem.count).to eq 19
      expect(Order.count).to eq 19
      expect(User.count).to eq 17
    end
  end
end