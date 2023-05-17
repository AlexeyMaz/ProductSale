require 'mysql2'

class ProductDbDataSource
  def initialize(host, username, password, database)
    @client = Mysql2::Client.new(
      host: host,
      username: username,
      password: password,
      database: database
    )
  end

  def add(product)
    query = "INSERT INTO Product (product_id, product_name, wholesale_price, retail_price) VALUES (#{product.id}, '#{product.product_name}', #{product.wholesale_price}, '#{product.retail_price}')"
    @client.query(query)
  end

  def change(product)
    query = "UPDATE Product SET product_name='#{product.product_name}', wholesale_price=#{product.wholesale_price}, retail_price='#{product.retail_price}' WHERE product_id=#{product.id}"
    @client.query(query)
  end

  def delete(id)
    query = "DELETE FROM Product WHERE product_id=#{id}"
    @client.query(query)
  end

  def get(id)
    query = "SELECT * FROM Product WHERE product_id=#{id}"
    result = @client.query(query).first
    if result
      Product.new(result['product_id'], result['product_name'], result['wholesale_price'], result['retail_price'])
    else
      nil
    end
  end

  def get_list(page_size, page_num, sort_field, sort_direction)
    offset = (page_num - 1) * page_size
    query = "SELECT * FROM Product ORDER BY #{sort_field} #{sort_direction} LIMIT #{page_size} OFFSET #{offset}"
    results = @client.query(query)
    products = []
    results.each do |result|
      products << Product.new(result['product_id'], result['product_name'], result['wholesale_price'], result['retail_price'])
    end
    products
  end
end
