module GDO::Core
  class Log
    
    DEBUG ||= 4
    INFO ||= 3
    WARNING ||= 2
    ERROR ||= 1
    CRITICAL ||= 0

    def self.init(path)
      @@path = "#{File.dirname(path)}/protected/logs"
    end
    
    def self.exception(exception)
      log('error', exception.message)
      trace = exception.backtrace || []
      log('criticial', exception.message + "\n" + trace.join("\n"))
    end
    
    def self.debug(message)
      log('debug', message)
    end

    def self.error(message)
      log('error', message)
    end

    def self.raw(file, line)
      log(file,line)
    end
    
    def self.info(message)
      log('info', message)
    end

    def self.log(file, line)
      
      puts line
    end
  end
end
