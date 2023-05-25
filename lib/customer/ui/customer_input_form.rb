require 'glimmer-dsl-libui'
require_relative '../controllers/customer_input_form_controller_create'
require './lib/models/Customer'
require 'win32api'

# класс, который реализует модальное окно для сущности заказчик,
# которое используется при добавлении или изменении записей через интерфейс
class CustomerInputForm
  include Glimmer

  def initialize(controller, existing_student = nil)
    @item = existing_student.to_hash unless existing_student.nil?
    @controller = controller
    @entries = {}
  end

  def on_create
    @controller.on_view_created
  end

  def create
    @root_container = window('Покупатель', 300, 150) {
      resizable false

      vertical_box {
        @student_form = form {
          stretchy false

          fields = [[:customer_name, 'Покупатель'], [:address, 'Адрес'], [:phone, 'Телефон']]

          fields.each do |field|
            @entries[field[0]] = entry {
              label field[1]
            }
          end
        }

        button('Сохранить') {
          stretchy false

          on_clicked {
            values = @entries.transform_values { |v| v.text.force_encoding("utf-8").strip }
            values.transform_values! { |v| v.empty? ? nil : v }

            @controller.process_fields(values)
          }
        }
      }
    }
    on_create
    @root_container
  end

  def set_value(field, value)
    return unless @entries.include?(field)

    @entries[field].text = value
  end

  def make_readonly(*fields)
    fields.each do |field|
      @entries[field].read_only = true
    end
  end

  def close
    @root_container.destroy
  end
end
