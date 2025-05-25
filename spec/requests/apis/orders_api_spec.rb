require 'rails_helper'

describe 'Orders API', type: :request do
  context 'GET /api/v1/orders/' do
    it 'lists all orders ordered by user_id, order_id and product_id' do
      user1 = User.create!(user_id: 9, name: 'Medeiros')
      user2 = User.create!(user_id: 5, name: 'Zarelli')

      order1 = Order.create!(user: user1, order_id: 455, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 259, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user2, order_id: 155, date: Date.new(2022, 12, 01))

      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)

      get '/api/v1/orders'

      json_response = JSON.parse(response.body)
      user_orders1 = json_response[0]
      user_orders2 = json_response[1]

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      expect(json_response.length).to eq 2
      
      expect(user_orders1['user_id']).to eq 5
      expect(user_orders1['name']).to eq 'Zarelli'

      expect(user_orders1.keys).not_to include('created_at')
      expect(user_orders1.keys).not_to include('updated_at')
      expect(user_orders1.keys).not_to include('id')

      expect(user_orders1['orders'][0].keys).not_to include('created_at')
      expect(user_orders1['orders'][0].keys).not_to include('updated_at')
      expect(user_orders1['orders'][0].keys).not_to include('id')
      expect(user_orders1['orders'][0].keys).not_to include('user_id')
      
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('created_at')
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('updated_at')
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('order_id')
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('id')
      
      expect(user_orders1['orders'].length).to eq 2
      expect(user_orders1['orders'][0]['order_id']).to eq 155
      expect(user_orders1['orders'][0]['date']).to eq '2022-12-01'
      expect(user_orders1['orders'][0]['total']).to eq '256.24'
      
      expect(user_orders1['orders'][0]['products'].length).to eq 1
      expect(user_orders1['orders'][0]['products'][0]['product_id']).to eq 122
      expect(user_orders1['orders'][0]['products'][0]['value']).to eq '256.24'

      expect(user_orders1['orders'][1]['order_id']).to eq 259
      expect(user_orders1['orders'][1]['date']).to eq '2020-12-01'
      expect(user_orders1['orders'][1]['total']).to eq '256.24'

      expect(user_orders1['orders'][1]['products'].length).to eq 1
      expect(user_orders1['orders'][1]['products'][0]['product_id']).to eq 111
      expect(user_orders1['orders'][1]['products'][0]['value']).to eq '256.24'

      expect(user_orders2['user_id']).to eq 9
      expect(user_orders2['name']).to eq 'Medeiros'

      expect(user_orders2['orders'].length).to eq 1
      expect(user_orders2['orders'][0]['order_id']).to eq 455
      expect(user_orders2['orders'][0]['date']).to eq '2021-12-01'
      expect(user_orders2['orders'][0]['total']).to eq '1024.48'

      expect(user_orders2['orders'][0]['products'].length).to eq 2
      expect(user_orders2['orders'][0]['products'][0]['product_id']).to eq 111
      expect(user_orders2['orders'][0]['products'][0]['value']).to eq '512.24'
      expect(user_orders2['orders'][0]['products'][1]['product_id']).to eq 122
      expect(user_orders2['orders'][0]['products'][1]['value']).to eq '512.24'
    end

    it 'returns empty if there are no orders' do
      get '/api/v1/orders'

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      expect(json_response).to eq []
    end

    it 'filters orders by start and end date' do
      user1 = User.create!(user_id: 1, name: 'Zarelli')
      user2 = User.create!(user_id: 2, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 1234, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 3457, date: Date.new(2022, 12, 01))

      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)

      get '/api/v1/orders?start_date=2020-12-01&end_date=2021-12-01'

      json_response = JSON.parse(response.body)
      user_orders1 = json_response[0]
      user_orders2 = json_response[1]

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      expect(json_response.length).to eq 2

      expect(user_orders1['user_id']).to eq 1
      expect(user_orders1['name']).to eq 'Zarelli'

      expect(user_orders1.keys).not_to include('created_at')
      expect(user_orders1.keys).not_to include('updated_at')
      expect(user_orders1.keys).not_to include('id')

      expect(user_orders1['orders'].length).to eq 1
      expect(user_orders1['orders'][0].keys).not_to include('created_at')
      expect(user_orders1['orders'][0].keys).not_to include('updated_at')
      expect(user_orders1['orders'][0].keys).not_to include('id')
      expect(user_orders1['orders'][0].keys).not_to include('user_id')

      expect(user_orders1['orders'][0]['order_id']).to eq 1234
      expect(user_orders1['orders'][0]['date']).to eq '2021-12-01'
      expect(user_orders1['orders'][0]['total']).to eq '1024.48'

      expect(user_orders1['orders'][0]['products'].length).to eq 2
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('created_at')
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('updated_at')
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('order_id')
      expect(user_orders1['orders'][0]['products'][0].keys).not_to include('id')

      expect(user_orders1['orders'][0]['products'][0]['product_id']).to eq 111
      expect(user_orders1['orders'][0]['products'][0]['value']).to eq '512.24'
      expect(user_orders1['orders'][0]['products'][1]['product_id']).to eq 122
      expect(user_orders1['orders'][0]['products'][1]['value']).to eq '512.24'

      expect(user_orders2['user_id']).to eq 2
      expect(user_orders2['name']).to eq 'Medeiros'

      expect(user_orders2['orders'].length).to eq 1
      expect(user_orders2['orders'][0]['order_id']).to eq 345
      expect(user_orders2['orders'][0]['date']).to eq '2020-12-01'
      expect(user_orders2['orders'][0]['total']).to eq '256.24'

      expect(user_orders2['orders'][0]['products'].length).to eq 1
      expect(user_orders2['orders'][0]['products'][0]['product_id']).to eq 111
      expect(user_orders2['orders'][0]['products'][0]['value']).to eq '256.24'
    end

    it 'filters orders by order id' do
      user1 = User.create!(user_id: 1, name: 'Zarelli')
      user2 = User.create!(user_id: 2, name: 'Medeiros')

      order1 = Order.create!(user: user1, order_id: 1234, date: Date.new(2021, 12, 01))
      order2 = Order.create!(user: user2, order_id: 345, date: Date.new(2020, 12, 01))
      order3 = Order.create!(user: user1, order_id: 3457, date: Date.new(2022, 12, 01))

      Product.create!(product_id: 111, value: 512.24, order: order1)
      Product.create!(product_id: 122, value: 512.24, order: order1)
      Product.create!(product_id: 111, value: 256.24, order: order2)
      Product.create!(product_id: 122, value: 256.24, order: order3)

      get '/api/v1/orders?order_id=345'

      json_response = JSON.parse(response.body)
      user_orders = json_response[0]

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      expect(json_response.length).to eq 1

      expect(user_orders['user_id']).to eq 2
      expect(user_orders['name']).to eq 'Medeiros'

      expect(user_orders['orders'].length).to eq 1
      expect(user_orders['orders'][0]['order_id']).to eq 345
      expect(user_orders['orders'][0]['date']).to eq '2020-12-01'
      expect(user_orders['orders'][0]['total']).to eq '256.24'

      expect(user_orders['orders'][0]['products'].length).to eq 1
      expect(user_orders['orders'][0]['products'][0]['product_id']).to eq 111
      expect(user_orders['orders'][0]['products'][0]['value']).to eq '256.24'
    end
  end

  context 'POST /api/v1/orders/import' do
    it 'creates users, products and orders from file' do
      post '/api/v1/orders/import',
        params: { file: fixture_file_upload('./spec/support/data_1.txt', 'multipart/form-data') }

      json_response = JSON.parse(response.body)
      first_user_orders = json_response[0]
      last_user_orders = json_response[-1]

      expect(Product.count).to eq 19
      expect(Order.count).to eq 19
      expect(User.count).to eq 17

      expect(response.status).to eq 201
      expect(response.content_type).to include('application/json')
      expect(json_response.length).to eq 17

      expect(first_user_orders['user_id']).to eq 1
      expect(first_user_orders['name']).to eq 'Sammie Baumbach'

      expect(first_user_orders['orders'].length).to eq 1
      expect(first_user_orders['orders'][0]['order_id']).to eq 7
      expect(first_user_orders['orders'][0]['total']).to eq '96.47'
      expect(first_user_orders['orders'][0]['date']).to eq '2021-05-28'

      expect(first_user_orders['orders'][0]['products'].length).to eq 1
      expect(first_user_orders['orders'][0]['products'][0]['product_id']).to eq 2
      expect(first_user_orders['orders'][0]['products'][0]['value']).to eq '96.47'
    end
  end
end