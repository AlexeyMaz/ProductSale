require 'mysql2'
require_relative '../data_sources/db_client'

class CustomerDbDataSource
  def initialize
    @client = DBClient.instance
  end

  def add(customer)
    query = "INSERT INTO Customer (customer_name, address, phone) VALUES ('#{customer.customer_name}', '#{customer.address}', '#{customer.phone}')"
    @client.query(query)
    customer_id = @client.last_id
    get(customer_id)
  end

  def change(customer)
    query = "UPDATE Customer SET customer_name='#{customer.customer_name}', address='#{customer.address}', phone='#{customer.phone}' WHERE customer_id=#{customer.id}"
    @client.query(query)
    get(customer.id)
  end

  def delete(id)
    query = "DELETE FROM Customer WHERE customer_id=#{id}"
    @client.query(query)
  end

  def get(id)
    query = "SELECT * FROM Customer WHERE customer_id=#{id}"
    result = @client.query(query).first
    if result
      Customer.new(result[:'customer_id'], result[:'customer_name'], result[:'address'], result[:'phone'])
    else
      nil
    end
  end

  def get_list(page_size, page_num, sort_field, sort_direction, has_address = nil, has_phone = nil)
    offset = (page_num - 1) * page_size
    query = 'SELECT * FROM Customer'

    if !has_address.nil? || !has_phone.nil?
      query += ' Where '
    end
    if has_address == true
      query += 'address IS NOT NULL '
    end
    if has_address == false
      query += 'address IS NULL '
    end
    if !has_address.nil? && !has_phone.nil?
      query += 'and '
    end
    if has_phone == true
      query += 'phone IS NOT NULL '
    end
    if has_phone == false
      query += 'phone IS NULL '
    end

    query += " ORDER BY #{sort_field} #{sort_direction} LIMIT #{page_size} OFFSET #{offset}"
    results = @client.query(query)
    customers = []
    results.each do |result|
      customers << Customer.new(result[:'customer_id'], result[:'customer_name'], result[:'address'], result[:'phone'])
    end
    customers
  end

  def count
    query = 'SELECT COUNT(*) FROM Customer'
    result = @client.query(query).first

    result[:'COUNT(*)']
  end
end
