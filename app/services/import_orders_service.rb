class ImportOrdersService
  def self.import_from_txt_file(file)
    File.open(file) do |file|
      file.each_line do |line|
        user_id = line[0..9].to_i
        name = line[10..54].lstrip
        order_id = line[55..64].to_i
        product_id = line[65..74].to_i
        value = line[75..86].lstrip.to_d
        date = line[87..94]&.to_date

        user = User.find_or_create_by(user_id:, name:)
        order = Order.find_or_create_by(order_id:, date:, user:)
        Product.find_or_create_by(product_id:, value:, order:)
      end
    end
  end
end