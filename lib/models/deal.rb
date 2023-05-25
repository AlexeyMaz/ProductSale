# модель для сущности Сделка
# данная модель реализует валидацию данных
class Deal
  attr_reader :id, :quantity, :customer_id, :product_id, :purchase_date

  def initialize(id, purchase_date, quantity, customer_id, product_id)
    validate_all_null(purchase_date, quantity, customer_id, product_id)
    @id = id
    @purchase_date = purchase_date
    @quantity = quantity
    @customer_id = customer_id
    @product_id = product_id
  end

  private

  def validate_all_null(*args)
    args.each do |arg|
      if arg.nil?
        raise ArgumentError, "Argument '#{caller_locations(1, 1)[0].label}' cannot be null"
      end
    end
  end
end
