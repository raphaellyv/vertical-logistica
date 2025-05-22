class Api::V1::OrdersController < ActionController::API
  def index
    users = User.all

    render status: 200, json: create_orders_list_json(users)
  end

  def query
    users = User.all

    render status: 200, json: create_filtered_orders_list_json(users)
  end

  private

  def create_filtered_orders_list_json(users)
    users.map do |user|
      create_user_orders_json(user:, orders: user.orders.where('date >= :start_date AND date <= :end_date', { start_date: params[:start_date].to_date, end_date: params[:end_date].to_date }))
    end
  end

  def create_orders_list_json(users)
    users.map{ |user| create_user_orders_json(user:, orders: user.orders) }
  end
  
  def create_user_orders_json(user:, orders:)
    user_json = user.as_json(except: %i[id created_at updated_at])
    orders_json = orders.map{ |order| create_order_json(order)}

    user_json[:orders] = orders_json
    user_json
  end
  
  def create_order_json(order)
    order_json = order.as_json(except: %i[id created_at updated_at user_id])

    order_json[:total] = order.calculate_total_value
    order_json[:products] = order.products.map{ |product| create_product_json(product) }
    order_json
  end

  def create_product_json(product)
    product.as_json(except: %i[id created_at updated_at order_id])
  end
end