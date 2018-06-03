module GDO::Core
  class Log

    def self.init(path)
      @@path = path
    end
    
    def self.exception(exception)
      log('error', exception.message)
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

    def self.log(file, line)
      puts line
    end
  end
end
