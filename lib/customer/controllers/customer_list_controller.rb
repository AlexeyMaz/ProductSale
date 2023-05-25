require './lib/state_holders/list_state_notifier'
require_relative '../ui/customer_input_form'
require_relative 'customer_input_form_controller_create'
require_relative 'customer_input_form_controller_edit'
require_relative '../customer_db_data_source'
require 'win32api'

# контроллер, которые отвечает за редактирование, удаление, добавление
# данных в рамках данной сущности
class CustomerListController

  attr_reader :state_notifier

  def initialize(view)
    @view = view
    @state_notifier = ListStateNotifier.new
    @state_notifier.add_listener(@view)
    @customer_rep = CustomerDbDataSource.new

    @sort_columns = %w[customer_id customer_name address phone]
    @sort_by = @sort_columns.first

    @address_filter_columns = [nil, true, false]
    @address_filter = @address_filter_columns.first

    @phone_filter_columns = [nil, true, false]
    @phone_filter = @phone_filter_columns.first
  end

  def show_view
    @view.create.show
  end

  def on_view_created
    # begin
    #   @student_rep = StudentRepository.new(DBSourceAdapter.new)
    # rescue Mysql2::Error::ConnectionError
    #   on_db_conn_error
    # end
  end

  def show_modal_add
    controller = CustomerInputFormControllerCreate.new(self)
    view = CustomerInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def show_modal_edit(current_page, per_page, selected_row)
    item = @state_notifier.get(selected_row)

    controller = CustomerInputFormControllerEdit.new(self, item)
    view = CustomerInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def delete_selected(current_page, per_page, selected_row)
    begin
      item = @state_notifier.get(selected_row)
      @customer_rep.delete(item.id)
      @state_notifier.delete(item)
    rescue
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, "Cannot delete this Customer(ID = " + item.id.to_s + ") because he is in assosiated with Deal", "Error", 0)
    end
  end

  def refresh_data(page, per_page)
    items = @customer_rep.get_list(per_page, page, @sort_by, 'ASC', @address_filter, @phone_filter)
    @state_notifier.set_all(items)
    @view.update_count(@customer_rep.count)
  end

  def sort(page, per_page, sort_index)
    @sort_by = @sort_columns[sort_index]
    refresh_data(page, per_page)
  end

  def filter_address(page, per_page, filter_index)
    @address_filter = @address_filter_columns[filter_index]
    refresh_data(page, per_page)
  end

  def filter_phone(page, per_page, filter_index)
    @phone_filter = @phone_filter_columns[filter_index]
    refresh_data(page, per_page)
  end


  private

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    exit(false)
  end
end
