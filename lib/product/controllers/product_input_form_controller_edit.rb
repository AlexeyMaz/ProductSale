require 'win32api'

class ProductInputFormControllerEdit
  def initialize(parent_controller, item)
    @parent_controller = parent_controller
    @item = item
    @product_rep = ProductDbDataSource.new
  end

  def set_view(view)
    @view = view
  end

  def on_view_created
    populate_fields(@item)
  end

  def populate_fields(item)
    @view.set_value(:product_name, item.product_name)
    @view.set_value(:wholesale_price, item.wholesale_price.to_s)
    @view.set_value(:retail_price, item.retail_price.to_s)
  end

  def process_fields(fields)
    begin
      item = Product.new(@item.id, *fields.values)
      item = @product_rep.change(item)
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
