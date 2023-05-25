require 'glimmer-dsl-libui'
require_relative '../controllers/customer_list_controller'
require_relative 'customer_input_form'

# Класс, который реализует представление для
# сущности Товар
class CustomerListView
  include Glimmer

  PAGE_SIZE = 20

  # при инициализации:
  # создаётся контроллер для сущности Товар
  # задаётся актуальная страница на представлении
  def initialize
    @controller = CustomerListController.new(self)
    @current_page = 1
    @total_count = 0
  end

  # при создании обновляется информация об сущности
  def on_create
    @controller.on_view_created
    @controller.refresh_data(@current_page, PAGE_SIZE)
  end

  # метод, в котором перезаписываетсся информация о сущности
  def update(customers)
    @items = []

    i = 0
    customers.each do |customer|
      i += 1
      item_num = ((@current_page - 1) * PAGE_SIZE) + i
      @items << Struct.new(:№, :id, :имя_покупателя, :адрес, :телефон).new(item_num, customer.id, customer.customer_name, customer.address, customer.phone)
    end

    @table.model_array = @items
    @page_label.text = "#{@current_page} / #{(@total_count / PAGE_SIZE.to_f).ceil}"
  end

  def update_count(new_cnt)
    @total_count = new_cnt
    @page_label.text = "#{@current_page} / #{(@total_count / PAGE_SIZE.to_f).ceil}"
  end

  def create
    root_container = horizontal_box {
      # Секция 1
      vertical_box {
        stretchy false

        vertical_box {
          stretchy false
          label {
            text 'Адрес'
          }

          combobox { |c|
            stretchy false
            items ['Неважно', 'Есть', 'Нет']
            selected 0
            on_selected do
              @controller.filter_address(@current_page, PAGE_SIZE, c.selected)
            end
          }
        }

        vertical_box {
          stretchy false
          label {
            text 'Телефон'
          }

          combobox { |c|
            stretchy false
            items ['Неважно', 'Есть', 'Нет']
            selected 0
            on_selected do
              @controller.filter_phone(@current_page, PAGE_SIZE, c.selected)
            end
          }
        }

        vertical_box {
          stretchy false
          label {
            text 'Сортировка'
          }

          combobox { |c|
            stretchy false
            items ['ID', 'Имя покупателя', 'Адрес', 'Телефон']
            selected 0
            on_selected do
              @controller.sort(@current_page, PAGE_SIZE, c.selected)
            end
          }
        }
      }

      # Секция 2
      vertical_box {
        @table = refined_table(
          table_editable: false,
          filter: lambda do |row_hash, query|
            utf8_query = query.force_encoding("utf-8")
            row_hash['имя покупателя'].include?(utf8_query)
          end,
          table_columns: {
            '№' => :text,
            'ID' => :text,
            'Имя покупателя' => :text,
            'Адрес' => :text,
            'Телефон' => :text
          },
          per_page: PAGE_SIZE
        )

        @pages = horizontal_box {
          stretchy false

          button("<") {
            stretchy true

            on_clicked do
              @current_page = [@current_page - 1, 1].max
              @controller.refresh_data(@current_page, PAGE_SIZE)
            end

          }
          @page_label = label("...") { stretchy false }
          button(">") {
            stretchy true

            on_clicked do
              @current_page = [@current_page + 1, (@total_count / PAGE_SIZE.to_f).ceil].min
              @controller.refresh_data(@current_page, PAGE_SIZE)
            end
          }
        }
      }

      # Секция 3
      vertical_box {
        stretchy false

        button('Добавить') {
          stretchy false

          on_clicked {
            @controller.show_modal_add
          }
        }
        button('Изменить') {
          stretchy false

          on_clicked {
            @controller.show_modal_edit(@current_page, PAGE_SIZE, @table.selection) unless @table.selection.nil?
          }
        }
        button('Удалить') {
          stretchy false

          on_clicked {
            @controller.delete_selected(@current_page, PAGE_SIZE, @table.selection) unless @table.selection.nil?
            @controller.refresh_data(@current_page, PAGE_SIZE)
          }
        }
        button('Обновить') {
          stretchy false

          on_clicked {
            @controller.refresh_data(@current_page, PAGE_SIZE)
          }
        }
      }
    }
    on_create
    root_container
  end
end
