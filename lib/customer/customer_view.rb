require 'glimmer-dsl-libui'
require './lib/models/customer'
require_relative 'customer_controller'

class CustomerView
  include Glimmer

  PAGE_SIZE = 10

  def initialize
    # @controller = TabStudentsController.new(self)
    @controller = CustomerController.new(self)
    @items = []
    @current_page = 1
    @total_count = 0

    @items = [
      Customer.new(1, 'Иван Иванов', 'ул. Центральная 1', '71234567890'),
      Customer.new(2, 'Елена Смирнова', 'пр. Солнечный 5', '79876543210'),
      Customer.new(3, 'Алексей Петров', 'ул. Лесная 10', '75551234567')
    ]

  end

  def on_create
    update(@items)
    # @controller.on_view_created
    # @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
    @controller.on_view_created
    @controller.refresh_data(@current_page, PAGE_SIZE)
  end

  def update(customers)
    @items = []

    customers.each do |customer|
      @items << Struct.new(:номер, :наименование_покупателя, :адрес, :телефон).new(customer.id, customer.customer_name, customer.address, customer.phone)
    end

    @table.model_array = @items
    @page_label.text = "#{@current_page} / #{(@total_count / PAGE_SIZE.to_f).ceil}"
  end

  def total_pages
    (@items.size.to_f / PAGE_SIZE).ceil
  end

  def update_student_count(new_cnt)
    @total_count = new_cnt
    @page_label.text = "#{@current_page} / #{(@total_count / PAGE_SIZE.to_f).ceil}"
  end

  def selected_index
    (@current_page - 1) * PAGE_SIZE
  end

  def displayed_items
    @items[selected_index, PAGE_SIZE] || []
  end

  def build
    root_container = horizontal_box {
      # Секция 1
      vertical_box {
        stretchy false

        form {
          stretchy false

          @company_name = entry {
            label 'наименование покупателя'
          }

          @address = entry {
            label 'адрес'
          }
        }
      }

      # Секция 2
      vertical_box {
        @table = refined_table(
          table_editable: false,
          filter: lambda do |row_hash, query|
            utf8_query = query.force_encoding("utf-8")
            row_hash['наименование покупателя'].include?(utf8_query)
          end,
          table_columns: {
            'id' => :text,
            'наименование покупателя' => :text,
            'адрес' => :text,
            'телефон' => :text
          }

        )

        @pages = horizontal_box {
          stretchy false

          button("<") {
            stretchy true

            on_clicked do
              @current_page = [@current_page - 1, 1].max
              # @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
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

        button('Добавить') { stretchy false }
        button('Изменить') { stretchy false }
        button('Удалить') { stretchy false }
        button('Обновить') {
          stretchy false

          on_clicked {
            # @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
          }
        }
      }
    }
    on_create
    root_container
  end

end