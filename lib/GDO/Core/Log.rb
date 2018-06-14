module GDO::Core
  class Log
    
    DEBUG ||= 4
    INFO ||= 3
    WARNING ||= 2
    ERROR ||= 1
    CRITICAL ||= 0

    def self.init(path, level)
      @@path = "#{File.dirname(path)}/protected/logs"
      @@level = level
    end

    def self.exception(exception)
      trace = exception.backtrace || []
      critical(exception.message + "\n" + trace.join("\n"))
    end
    def self.critical(message)
      log('criticial', message)
    end
    def self.error(message)
      log('error', message)
    end
    def self.warning(message)
      log('warning', message)
    end
    def self.info(message)
      log('info', message)
    end
    def self.debug(message)
      log('debug', message)
    end
    def self.raw(file, line)
      log(file,line)
    end
    def self.log(file, line)
      puts line
    end
  end
end
