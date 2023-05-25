require 'minitest/autorun'
require './lib/models/Customer'
require './lib/models/Deal'
require './lib/models/Product'

class CustomerTest < Minitest::Test
  def test_customer_with_valid_data
    customer = Customer.new(1, 'ABC Company', 'Address', '89004562310')
    assert_equal 1, customer.id
    assert_equal 'ABC Company', customer.customer_name
    assert_equal 'Address', customer.address
    assert_equal '89004562310', customer.phone
  end

  def test_customer_with_null_id
    error = assert_raises(ArgumentError) do
      Customer.new(nil, 'ABC Company', 'Address', '89004562310')
    end
    assert_equal "Argument 'id' cannot be null", error.message
  end

  def test_customer_with_null_customer_name
    error = assert_raises(ArgumentError) do
      Customer.new(1, nil, 'Address', '89004562310')
    end
    assert_equal "Argument 'customer_name' cannot be null", error.message
  end

  def test_customer_with_invalid_phone_format
    error = assert_raises(ArgumentError) do
      Customer.new(1, 'ABC Company', 'Address', '8900456231')
    end
    assert_equal "Invalid phone format: 8900456231", error.message
  end
end


class DealTest < Minitest::Test
  def test_deal_with_valid_data
    deal = Deal.new(1, '2023-05-21', 5, 1, 1)
    assert_equal 1, deal.id
    assert_equal '2023-05-21', deal.purchase_date
    assert_equal 5, deal.quantity
    assert_equal 1, deal.customer_id
    assert_equal 1, deal.product_id
  end

  def test_deal_with_null_purchase_date
    error = assert_raises(ArgumentError) do
      Deal.new(1, nil, 5, 1, 1)
    end
    assert_equal "Argument 'purchase_date' cannot be null", error.message
  end

  def test_deal_with_null_quantity
    error = assert_raises(ArgumentError) do
      Deal.new(1, '2023-05-21', nil, 1, 1)
    end
    assert_equal "Argument 'quantity' cannot be null", error.message
  end

  def test_deal_with_null_customer_id
    error = assert_raises(ArgumentError) do
      Deal.new(1, '2023-05-21', 5, nil, 1)
    end
    assert_equal "Argument 'customer_id' cannot be null", error.message
  end

  def test_deal_with_null_product_id
    error = assert_raises(ArgumentError) do
      Deal.new(1, '2023-05-21', 5, 1, nil)
    end
    assert_equal "Argument 'product_id' cannot be null", error.message
  end
end


class ProductTest < Minitest::Test
  def test_product_with_valid_data
    product = Product.new(1, 'Product 1', 10, 20)
    assert_equal 1, product.id
    assert_equal 'Product 1', product.name
    assert_equal 10, product.wholesale_price
    assert_equal 20, product.retail_price
  end

  def test_product_with_null_name
    error = assert_raises(ArgumentError) do
      Product.new(1, nil, 10, 20)
    end
    assert_equal "Argument 'product_name' cannot be null", error.message
  end

  def test_product_with_null_wholesale_price
    error = assert_raises(ArgumentError) do
      Product.new(1, 'Product 1', nil, 20)
    end
    assert_equal "Argument 'wholesale_price' cannot be null", error.message
  end

  def test_product_with_zero_wholesale_price
    error = assert_raises(ArgumentError) do
      Product.new(1, 'Product 1', 0, 20)
    end
    assert_equal "Argument 'wholesale_price' must be greater than zero", error.message
  end

  def test_product_with_null_retail_price
    error = assert_raises(ArgumentError) do
      Product.new(1, 'Product 1', 10, nil)
    end
    assert_equal "Argument 'retail_price' cannot be null", error.message
  end

  def test_product_with_zero_retail_price
    error = assert_raises(ArgumentError) do
      Product.new(1, 'Product 1', 10, 0)
    end
    assert_equal "Argument 'retail_price' must be greater than zero", error.message
  end
end
