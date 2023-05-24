class Customer
  PHONE_REGEX = /^\+?[78] ?[(-]?\d{3} ?[)-]?[ -]?\d{3}[ -]?\d{2}[ -]?\d{2}$/
  attr_accessor :id, :customer_name, :address, :phone

  def initialize(id, customer_name, address = nil, phone = nil)
    validate_all_null(customer_name)
    validate_phone(phone)
    @id = id
    @customer_name = customer_name
    @address = address
    @phone = phone
  end


  private

  def validate_all_null(*args)
    args.each do |arg|
      if arg.nil?
        raise ArgumentError, "Argument '#{caller_locations(1, 1)[0].label}' cannot be null"
      end
    end
  end

  def validate_phone(phone)
    if phone && !phone.match?(PHONE_REGEX)
      raise ArgumentError, "Invalid phone format: #{phone}"
    end
  end
end
