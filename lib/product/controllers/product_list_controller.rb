require './lib/state_holders/list_state_notifier'
require_relative '../ui/product_input_form'
require_relative 'product_input_form_controller_create'
require_relative 'product_input_form_controller_edit'
require_relative '../product_db_data_source'
require 'win32api'

class ProductListController
  attr_reader :state_notifier

  def initialize(view)
    @view = view
    @state_notifier = ListStateNotifier.new
    @state_notifier.add_listener(@view)
    @product_rep = ProductDbDataSource.new

    @sort_columns = %w[product_id product_name wholesale_price retail_price]
    @sort_by = @sort_columns.first
  end

  def on_view_created
    # begin
    #   @student_rep = StudentRepository.new(DBSourceAdapter.new)
    # rescue Mysql2::Error::ConnectionError
    #   on_db_conn_error
    # end
  end

  def show_view
    @view.create.show
  end

  def show_modal_add
    controller = ProductInputFormControllerCreate.new(self)
    view = ProductInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def show_modal_edit(current_page, per_page, selected_row)
    item = @state_notifier.get(selected_row)

    controller = ProductInputFormControllerEdit.new(self, item)
    view = ProductInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def delete_selected(current_page, per_page, selected_row)
    begin
      item = @state_notifier.get(selected_row)
      @product_rep.delete(item.id)
      @state_notifier.delete(item)
    rescue
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, "Cannot delete this Product(ID = " + item.id.to_s + ") because it is in assosiated with Deal", "Error", 0)
    end
  end

  def refresh_data(page, per_page)
    items = @product_rep.get_list(per_page, page, @sort_by, 'ASC')
    @state_notifier.set_all(items)
    @view.update_count(@product_rep.count)
  end

  def sort(page, per_page, sort_index)
    @sort_by = @sort_columns[sort_index]
    refresh_data(page, per_page)
  end

  private

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    exit(false)
  end
end
