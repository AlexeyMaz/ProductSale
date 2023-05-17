class Customer
  attr_accessor :id, :customer_name, :address, :phone

  def initialize(id, customer_name, address, phone)
    @id = id
    @customer_name = customer_name
    @address = address
    @phone = phone
  end
end
