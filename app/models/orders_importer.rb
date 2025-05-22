class OrdersImporter
  def self.import_file(path)
    File.open(path) do |file|
      file.each_line do |line|
        user_id = line[0..9].to_i
        user_name = line[10..54].lstrip
        order_id = line[55..64].to_i
        product_id = line[65..74].to_i
        product_value = line[75..86].lstrip.to_d
        order_date = line[87..94]&.to_date

        user = User.find_or_create_by(user_id: user_id, name: user_name)
        order = Order.find_or_create_by(order_id: order_id, date: order_date, user: user)
        Product.find_or_create_by(product_id: product_id, value: product_value, order: order)
      end
    end
  end
end