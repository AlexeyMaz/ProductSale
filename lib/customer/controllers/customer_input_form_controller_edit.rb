require 'win32api'

# контроллер, которые отвечает за редактирование
# данных в рамках данной сущности
class CustomerInputFormControllerEdit
  def initialize(parent_controller, item)
    @parent_controller = parent_controller
    @item = item
    @customer_rep = CustomerDbDataSource.new
  end

  def set_view(view)
    @view = view
  end

  def on_view_created
    populate_fields(@item)
  end

  def populate_fields(item)
    @view.set_value(:customer_name, item.customer_name)
    @view.set_value(:address, item.address)
    @view.set_value(:phone, item.phone)
  end

  def process_fields(fields)
    begin
      item = Customer.new(@item.id, *fields.values)
      item = @customer_rep.change(item)
      @parent_controller.state_notifier.replace(@item, item)
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
