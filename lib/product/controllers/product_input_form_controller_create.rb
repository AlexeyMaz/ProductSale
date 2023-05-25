require 'win32api'

# контроллер, которые отвечает за создание
# данных в рамках данной сущности
class ProductInputFormControllerCreate
  def initialize(parent_controller)
    @parent_controller = parent_controller
    @product_rep = ProductDbDataSource.new
  end

  def set_view(view)
    @view = view
  end

  def on_view_created
    # @view.make_readonly(:delivery)
  end

  def process_fields(fields)
    begin
      item = Product.new(-1, *fields.values)
      item = @product_rep.add(item)
      @parent_controller.state_notifier.add(item)
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
