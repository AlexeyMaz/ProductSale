require './lib/views/main_window'
require './lib/repositories/student_repository'
require './lib/repositories/adapters/db_source_adapter'
require './lib/repositories/containers/data_list_student_short'
require './lib/state_holders/list_state_notifier'
require_relative 'customer_db_data_source'
require 'win32api'

class CustomerController
  def initialize(view)
    @view = view
    @state_notifier = ListStateNotifier.new
    @state_notifier.add_listener(@view)
    @customer_rep = CustomerDbDataSource.new
  end

  def edit(number)
    customer = @state_notifier.get(number)
    puts customer.id
    # @view.show_edit_dialog(author)
  end

  def add(number)
    customer = @state_notifier.get(number)
    puts customer
    # @view.show_add_dialog(author)
  end

  def remove(number)
    customer = @state_notifier.get(number)
    puts customer
    # @view.show_remove_dialog(author)
  end

  def refresh_data(page, per_page)
    items = @customer_rep.get_list(per_page, page, 'customer_name', 'ASC')
    @state_notifier.set_all(items)
    @view.update_student_count(@customer_rep.count)
  end

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    exit(false)
  end
end
