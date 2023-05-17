require_relative 'views/main_window'
require './LabStudents/util/logger'

LoggerClass.instance.level = Logger::DEBUG
MainWindow.new.create.show
