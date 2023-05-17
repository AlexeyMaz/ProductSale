require 'glimmer-dsl-libui'
require_relative 'tab_students'
require_relative '../customer/customer_view'
require './lib/customer/customer_view'

class MainWindow
  include Glimmer

  def initialize
    @view_tab_students = TabStudents.new
  end

  def create
    window('Sales', 900, 200) {
      tab {
        tab_item('Покупатели') {
          CustomerView.new.build
        }

        # tab_item('Вкладка 2') { }
        # tab_item('Вкладка 3') { }
      }
    }
  end
end
