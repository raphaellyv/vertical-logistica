class Api::V1::OrdersController < ActionController::API
  def index
    users = OrdersListSerializer.create_serialized_hash_array(filters: filter_params)
    render status: 200, json: users
  end

  def import
    ImportOrdersService.import_from_txt_file(params[:file])

    users = OrdersListSerializer.create_serialized_hash_array(filters: filter_params)
    render status: 201, json: users
  end

  private

  def paginated_users
    page = params[:page].to_i || 1
    per_page = 5
    offset = (page - 1) * per_page

    User.order(:user_id).limit(per_page).offset(offset)
  end

  def filter_params
    filter_keys = %i[start_date end_date order_id]
    filter_keys.each_with_object({}) { |key, hash| hash[key] = params[key.to_s] }
  end
end
