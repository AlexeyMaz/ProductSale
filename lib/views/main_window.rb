require 'glimmer-dsl-libui'
require './lib/customer/ui/customer_list_view'
require './lib/product/ui/product_list_view'

class MainWindow
  include Glimmer

  def initialize
  end

  def create
    window('Sales', 900, 500) {
      tab {
        tab_item('Покупатели') {
          CustomerListView.new.create
        }

        tab_item('Товары') {
          ProductListView.new.create
        }

      }
    }
  end
end
