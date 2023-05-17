require_relative 'views/main_window'
require './lib/util/logger'

LoggerClass.instance.level = Logger::DEBUG
MainWindow.new.create.show
