class Product
  attr_accessor :id, :product_name, :wholesale_price, :retail_price

  def initialize(id, product_name, wholesale_price, retail_price)
    @id = id
    @product_name = product_name
    @wholesale_price = wholesale_price
    @retail_price = retail_price
  end
end
