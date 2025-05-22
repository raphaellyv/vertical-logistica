class Api::V1::OrdersController < ActionController::API
  def index
    render status: 200, json: create_orders_list_json
  end

  private

  def create_orders_list_json
    start_date_params = params[:start_date]
    end_date_params = params[:end_date]
    order_id_params = params[:order_id]

    User.all.map{ |user| create_user_orders_json(user:, start_date_params:, end_date_params:, order_id_params:) }.compact
  end
  
  def create_user_orders_json(user:, start_date_params:, end_date_params:, order_id_params:)
    orders = user.orders

    if start_date_params
      start_date = start_date_params.to_date
      orders = orders.where('date >= ?', start_date)
    end

    if end_date_params
      end_date =end_date_params.to_date
      orders = orders.where('date <= ?', end_date)
    end

    if order_id_params
      orders = orders.where('order_id like ?', order_id_params + '%')
    end

    if orders.any?
      user_json = user.as_json(except: %i[id created_at updated_at])
      orders_json = orders.map{ |order| create_order_json(order)}

      user_json[:orders] = orders_json
      user_json
    end
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