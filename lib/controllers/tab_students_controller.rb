require './lib/views/main_window'
require './lib/repositories/student_repository'
require './lib/repositories/adapters/db_source_adapter'
require './lib/repositories/containers/data_list_student_short'
require './lib/views/student_input_form'
require './lib/controllers/student_input_form/student_input_form_controller_create'
require './lib/controllers/student_input_form/student_input_form_controller_edit'
require './lib/views/edit.rb'
require './lib/util/logger'
require 'win32api'

##
# Контроллер для вкладки со списком студентов
class TabStudentsController
  def initialize(view)
    LoggerClass.instance.debug('TabStudentsController: init start')
    @view = view
    @data_list = DataListStudentShort.new([])
    @data_list.add_listener(@view)
    LoggerClass.instance.debug('TabStudentsController: init done')
  end

  ##
  # Вызывается из view после ее создания
  def on_view_created
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
      LoggerClass.instance.debug('TabStudentsController: created student repository')
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  ##
  # Показать модальное окно с добавлением студента
  def show_modal_add(current_page, per_page)
    LoggerClass.instance.debug('TabStudentsController: showing modal (add)')
    controller = StudentInputFormControllerCreate.new(self)
    view = StudentInputForm.new(controller, AddAll.new, lambda {refresh_data(current_page, per_page)})
    controller.set_view(view)
    view.create.show
  end

  ##
  # Показать модальное окно с изменением выделенного студента
  def show_modal_edit(current_page, per_page, selected_row, edit)
    LoggerClass.instance.debug('TabStudentsController: showing modal (edit)')
    student_num = (current_page - 1) * per_page + selected_row
    @data_list.select_element(student_num)
    student_id = @data_list.selected_id
    controller = StudentInputFormControllerEdit.new(self, student_id)
    view = StudentInputForm.new(controller, edit, lambda {refresh_data(current_page, per_page)})
    controller.set_view(view)
    view.create.show
  end

  ##
  # Удалить выбранных студентов
  def delete_selected(current_page, per_page, selected_row)
    begin
      LoggerClass.instance.debug('TabStudentsController: deleting selected student')
      student_num = (current_page - 1) * per_page + selected_row
      @data_list.select_element(student_num)
      student_id = @data_list.selected_id
      @student_rep.remove_student(student_id)
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  ##
  # Обновить данные в таблице студентов
  def refresh_data(page, per_page)
    begin
      LoggerClass.instance.debug('TabStudentsController: refreshing data...')
      @data_list = @student_rep.paginated_short_students(page, per_page, @data_list)
      @view.update_student_count(@student_rep.student_count)
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  private

  ##
  # Обработчик ошибки подключения к БД
  def on_db_conn_error(error)
    LoggerClass.instance.error('TabStudentsController: DB connection error:')
    LoggerClass.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    # TODO: Возможность переключения на JSON помимо exit
    exit(false)
  end
end
