class Deal
  attr_reader :id, :quantity, :customer_id, :product_id, :purchase_date

  def initialize(id, purchase_date, quantity, customer_id, product_id)
    @id = id
    @purchase_date = purchase_date
    @quantity = quantity
    @customer_id = customer_id
    @product_id = product_id
  end
end
