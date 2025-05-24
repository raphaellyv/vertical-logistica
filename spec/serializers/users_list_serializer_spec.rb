require 'rails_helper'

describe 'UsersListSerializer' do
  context '.create_serialized_hash' do
    it 'returns a list of users with their orders' do
      user1 = User.create!(user_id: 9, name: 'Medeiros')
      user2 = User.create!(user_id: 5, name: 'Zarelli')

      order1 = Order.create!(user: user1, order_id: 455, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user1, order_id: 259, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user2, order_id: 155, date: Date.new(2022, 12, 01))

      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)

      serialized_users_list = UsersListSerializer.create_serialized_hash_array(User.all)

      expect(serialized_users_list.length).to eq 2
      expect(serialized_users_list[0].keys).to eq ['user_id', 'name', 'orders']
      expect(serialized_users_list[0]['user_id']).to eq 5
      expect(serialized_users_list[0]['name']).to eq 'Zarelli'

      expect(serialized_users_list[1]['user_id']).to eq 9
      expect(serialized_users_list[1]['name']).to eq 'Medeiros'

      expect(serialized_users_list[0]['orders'].length).to eq 1
      expect(serialized_users_list[0]['orders'][0]['order_id']).to eq 155

      expect(serialized_users_list[0]['orders'][0]['date']).to eq Date.new(2022, 12, 01)
      expect(serialized_users_list[0]['orders'][0]['total']).to eq 256.24

      expect(serialized_users_list[0]['orders'][0]['products'].length).to eq 1
      expect(serialized_users_list[0]['orders'][0]['products'][0]['product_id']).to eq 122
      expect(serialized_users_list[0]['orders'][0]['products'][0]['value']).to eq 256.24


      expect(serialized_users_list[1]['orders'].length).to eq 2
      expect(serialized_users_list[1]['orders'][0].keys).to eq ['order_id', 'date','total',  'products']

      expect(serialized_users_list[1]['orders'][0]['order_id']).to eq 259
      expect(serialized_users_list[1]['orders'][0]['date']).to eq Date.new(2020, 12, 01)
      expect(serialized_users_list[1]['orders'][0]['total']).to eq 256.24
      expect(serialized_users_list[1]['orders'][0]['products'].length).to eq 1

      expect(serialized_users_list[1]['orders'][1]['order_id']).to eq 455
      expect(serialized_users_list[1]['orders'][1]['date']).to eq Date.new(2021, 12, 01)
      expect(serialized_users_list[1]['orders'][1]['total']).to eq 1024.48

      expect(serialized_users_list[1]['orders'][1]['products'].length).to eq 2
      expect(serialized_users_list[1]['orders'][0]['products'][0].keys).to eq ['product_id', 'value']

      expect(serialized_users_list[1]['orders'][0]['products'][0]['product_id']).to eq 111
      expect(serialized_users_list[1]['orders'][0]['products'][0]['value']).to eq 256.24

      expect(serialized_users_list[1]['orders'][1]['products'][0]['product_id']).to eq 111
      expect(serialized_users_list[1]['orders'][1]['products'][0]['value']).to eq 512.24

      expect(serialized_users_list[1]['orders'][1]['products'][1]['product_id']).to eq 122
      expect(serialized_users_list[1]['orders'][1]['products'][1]['value']).to eq 512.24
    end
  end
end