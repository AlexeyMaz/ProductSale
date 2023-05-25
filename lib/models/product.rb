class Product
  attr_reader :id, :product_name, :wholesale_price, :retail_price

  def initialize(id, product_name, wholesale_price, retail_price)
    validate_null('product_name', product_name)
    validate_null('wholesale_price', wholesale_price)
    validate_null('retail_price', retail_price)
    validate_pos('wholesale_price', wholesale_price)
    validate_pos('retail_price', retail_price)
    @id = id
    @product_name = product_name
    @wholesale_price = wholesale_price
    @retail_price = retail_price
  end

  private

  def validate_null(name, value)
    if value.nil?
      raise ArgumentError, "Argument '#{name}' cannot be null"
    end
  end

  def validate_pos(name, value)
    if value.to_i <= 0
      raise ArgumentError, "Argument '#{name}' must be greater than zero"
    end
  end
end
