class Api::V1::OrdersController < ActionController::API
  def index
    users = User.all
    render status: 200, json: users.map{ |user| create_orders_list_json(user) }
  end

  private
  
  def create_orders_list_json(user)
    user_json = user.as_json(except: %i[id created_at updated_at])
    orders_json = user.orders.map{ |order| create_order_json(order)}

    user_json[:orders] = orders_json
    user_json
  end

  def create_order_json(order)
    order_json = order.as_json(except: %i[id created_at updated_at user_id total])

    order_json[:total] = order.calculate_total_value
    order_json[:products] = order.products.map{ |product| create_product_json(product) }
    order_json
  end

  def create_product_json(product)
    product.as_json(except: %i[id created_at updated_at order_id])
  end
end