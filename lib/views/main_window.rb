require 'glimmer-dsl-libui'
require_relative 'tab_students'
require_relative '../customer/ui/customer_view'
require_relative '../customer/ui/customer_list_view'
class MainWindow
  include Glimmer

  def initialize
    @view_tab_students = TabStudents.new
  end

  def create
    window('Sales', 1000, 400) {
      tab {
        tab_item('Покупатели') {
          CustomerListView.new.create
        }

        # tab_item('Вкладка 2') { }
        # tab_item('Вкладка 3') { }
      }
    }
  end
end
