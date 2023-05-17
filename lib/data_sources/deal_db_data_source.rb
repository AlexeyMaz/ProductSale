require 'mysql2'

class DealDbDataSource
  def initialize(host, username, password, database)
    @client = Mysql2::Client.new(
      host: host,
      username: username,
      password: password,
      database: database
    )
  end

  def add(deal)
    query = "INSERT INTO Deal (deal_id, customer_id, product_id, quantity, purchase_date) VALUES (#{deal.id}, #{deal.customer_id}, #{deal.product_id}, #{deal.quantity}, '#{deal.purchase_date}')"
    @client.query(query)
  end

  def change(deal)
    query = "UPDATE Deal SET customer_id=#{deal.customer_id}, product_id=#{deal.product_id}, quantity=#{deal.quantity}, purchase_date='#{deal.purchase_date}' WHERE deal_id=#{deal.id}"
    @client.query(query)
  end

  def delete(id)
    query = "DELETE FROM Deal WHERE deal_id=#{id}"
    @client.query(query)
  end

  def get(id)
    query = "SELECT * FROM Deal WHERE deal_id=#{id}"
    result = @client.query(query).first
    if result
      Deal.new(result['deal_id'], result['customer_id'], result['product_id'], result['quantity'], result['purchase_date'])
    else
      nil
    end
  end

  def get_list(page_size, page_num, sort_field, sort_direction)
    offset = (page_num - 1) * page_size
    query = "SELECT * FROM Deal ORDER BY #{sort_field} #{sort_direction} LIMIT #{page_size} OFFSET #{offset}"
    results = @client.query(query)
    deals = []
    results.each do |result|
      deals << Deal.new(result['deal_id'], result['customer_id'], result['product_id'], result['quantity'], result['purchase_date'])
    end
    deals
  end
end
