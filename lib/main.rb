require_relative 'views/main_window'
require_relative 'logger'

LoggerHolder.instance.level = Logger::DEBUG
# создаёт окно, в котором и происходит вся работа в рамках поставленной индивидуальной задачи
MainWindow.new.create.show
