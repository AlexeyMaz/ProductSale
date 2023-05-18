require 'glimmer-dsl-libui'
require_relative '../controllers/customer_list_controller'
require_relative '../controllers/customer_controller'
require_relative 'customer_input_form'

class CustomerListView
  include Glimmer

  PAGE_SIZE = 20

  def initialize
    @controller = CustomerListController.new(self)
    @current_page = 1
    @total_count = 0
  end

  def on_create
    @controller.on_view_created
    @controller.refresh_data(@current_page, PAGE_SIZE)
  end

  # Метод наблюдателя datalist
  # def on_datalist_changed(new_table)
  #   arr = new_table.to_2d_array
  #   arr.map do |row|
  #     row[3] = [row[3][:value], contact_color(row[3][:type])] unless row[3].nil?
  #   end
  #   @table.model_array = arr
  # end

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

  def update_student_count(new_cnt)
    @total_count = new_cnt
    @page_label.text = "#{@current_page} / #{(@total_count / PAGE_SIZE.to_f).ceil}"
  end

  def create
    root_container = horizontal_box {
      # Секция 1
      vertical_box {
        stretchy false

        form {
          stretchy false

          @filter_customer_name = entry {
            label 'Имя покупателя'
          }

          @filter_address = entry {
            label 'Адресс'
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
            'id' => :text,
            'имя покупателя' => :text,
            'адрес' => :text,
            'телефон' => :text
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
