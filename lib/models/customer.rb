# модель для сущности Покупатель
# данная модель реализует валидацию данных
class Customer
  PHONE_REGEX = /^\+?[78] ?[(-]?\d{3} ?[)-]?[ -]?\d{3}[ -]?\d{2}[ -]?\d{2}$/
  attr_reader :id, :customer_name, :address, :phone

  def initialize(id, customer_name, address = nil, phone = nil)
    validate_null('id', id)
    validate_null('customer_name', customer_name)
    validate_phone(phone)
    @id = id
    @customer_name = customer_name
    @address = address
    @phone = phone
  end

  private

  def validate_null(name, value)
    if value.nil?
      raise ArgumentError, "Argument '#{name}' cannot be null"
    end
  end

  def validate_phone(phone)
    if phone && !phone.match?(PHONE_REGEX) && phone != ''
      raise ArgumentError, "Invalid phone format: #{phone}"
    end
  end
end
