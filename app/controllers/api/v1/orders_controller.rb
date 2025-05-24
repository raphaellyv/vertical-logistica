class Api::V1::OrdersController < ActionController::API
  def index
    users = UsersListSerializer.create_serialized_hash_array(paginated_users)
    render status: 200, json: users
  end

  def import
    ImportOrdersService.import_from_txt_file(params[:file])

    users = UsersListSerializer.create_serialized_hash_array(paginated_users)
    render status: 201, json: users
  end

  private

  def paginated_users
    page = params[:page].to_i || 1
    per_page = 5
    offset = (page - 1) * per_page

    User.order(:user_id).limit(per_page).offset(offset)
  end
  # def ordered_serialized_users
  #   User.all.order(:user_id).map{ |user| UserOrdersSerializer.create_serialized_hash(user) }
  # end

  # def create_orders_list_json
  #   start_date_params = params[:start_date]
  #   end_date_params = params[:end_date]
  #   order_id_params = params[:order_id]
    
  #   page = params[:page].to_i || 1
  #   per_page = 5
  #   offset = (page - 1) * per_page
  #   ordered_users = User.all.limit(per_page).offset(offset).order(:user_id)

  #   ordered_users.map{ |user| create_user_orders_json(user:, start_date_params:, end_date_params:, order_id_params:) }.compact
  # end
  
  # def create_user_orders_json(user:, start_date_params:, end_date_params:, order_id_params:)
  #   orders = user.orders.order(:order_id)

  #   if start_date_params
  #     orders = orders.filter_by_start_date_string(start_date_params)
  #   end

  #   if end_date_params
  #     orders = orders.filter_by_end_date_string(end_date_params)
  #   end

  #   if order_id_params
  #     orders = orders.filter_by_order_id(order_id_params)
  #   end

  #   if orders.any?
  #     user_json = user.as_json(only: %i[user_id name])
  #     orders_json = orders.map{ |order| create_order_json(order)}

  #     user_json[:orders] = orders_json
  #     user_json
  #   end
  # end
  
  # def create_order_json(order)
  #   order_json = order.as_json(only: %i[order_id date])
  #   ordered_products = order.products.order(:product_id)

  #   order_json[:total] = order.calculate_total_value
  #   order_json[:products] = ordered_products.map{ |product| create_product_json(product) }
  #   order_json
  # end

  # def create_product_json(product)
  #   product.as_json(only: %i[product_id value])
  # end
end
