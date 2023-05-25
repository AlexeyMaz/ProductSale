require 'glimmer-dsl-libui'
require './lib/customer/ui/customer_list_view'
require './lib/product/ui/product_list_view'

# класс MainWindow, который из файлов реализованных сущностей создаёт
# их view и отрисовывает их на экране пользователя
# конкретно сейчас класс отрисовывает сущности Товар и Покупатель
class MainWindow
  include Glimmer

  def initialize
  end

  # метод, в котором происходит создание окон
  # для сущностей Покупатель и Товар
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
