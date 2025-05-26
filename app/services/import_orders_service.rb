class ImportOrdersService
  def self.import_from_txt_file(file)
    File.open(file) do |file|
      users = []
      orders = []
      products = []
      product_items = []

      file.each_line do |line|
        user_id = line[0..9].to_i
        name = line[10..54].lstrip
        order_id = line[55..64].to_i
        product_id = line[65..74].to_i
        value = line[75..86].lstrip.to_d
        date = line[87..94]&.to_date

        users << { user_id: user_id, name: name }
        orders << { order_id: order_id, date: date, user_id: user_id }
        products << { product_id: product_id, value: value }
        product_items << { product_id: product_id, value: value, order_id: order_id }
      end

      User.insert_all(users.uniq)
      Order.insert_all(orders.uniq)
      Product.insert_all(products.uniq)
      
      product_items.uniq.each do |item|
        new_product_id = Product.find_by(product_id: item[:product_id], value: item[:value]).id
        ProductItem.insert({ product_id: new_product_id, order_id: item[:order_id] })
      end
    end
  end
end