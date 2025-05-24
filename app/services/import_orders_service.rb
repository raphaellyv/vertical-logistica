class ImportOrdersService
  def self.import_from_txt_file(file)
    File.open(file) do |file|
      users = []
      orders = []
      products = []

      file.each_line do |line|
        user_id = line[0..9].to_i
        name = line[10..54].lstrip
        order_id = line[55..64].to_i
        product_id = line[65..74].to_i
        value = line[75..86].lstrip.to_d
        date = line[87..94]&.to_date

        users << { user_id: user_id, name: name }
        orders << { order_id: order_id, date: date, user_id: user_id }
        products << { product_id: product_id, value: value, order_id: order_id }
      end

      User.insert_all(users)
      Order.insert_all(orders)
      Product.insert_all(products)
    end
  end
end