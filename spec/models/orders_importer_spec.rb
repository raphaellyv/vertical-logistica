require 'rails_helper'

RSpec.describe OrdersImporter, type: :model do
  context '.import_file' do
    it 'imports new orders from file' do
      OrdersImporter.import_file('./spec/support/data_1.txt')

      expect(Product.all.length).to eq 19
      expect(Order.all.length).to eq 19
      expect(User.all.length).to eq 17
    end
  end
end