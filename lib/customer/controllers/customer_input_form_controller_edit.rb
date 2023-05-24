require 'win32api'

class CustomerInputFormControllerEdit
  def initialize(parent_controller, item_id)
    @parent_controller = parent_controller
    @item_id = item_id
    @customer_rep = CustomerDbDataSource.new
  end

  def set_view(view)
    @view = view
  end

  def on_view_created
    # begin
    #   @student_rep = StudentRepository.new(DBSourceAdapter.new)
    # rescue Mysql2::Error::ConnectionError
    #   on_db_conn_error
    # end
    # @existing_student = @student_rep.student_by_id(@existing_student_id)
    @item = @customer_rep.get(@item_id)

    # @view.make_readonly(:git, :telegram, :email, :phone)
    populate_fields(@item)
  end

  def populate_fields(item)
    @view.set_value(:customer_name, item.customer_name)
    @view.set_value(:address, item.address)
    @view.set_value(:phone, item.phone)
  end

  def process_fields(fields)
    begin
      new_item = Customer.new(@item_id, *fields.values)
      @customer_rep.change(new_item)
      @view.close
    rescue ArgumentError => e
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  private

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end