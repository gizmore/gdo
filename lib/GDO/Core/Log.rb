module GDO::Core
  class Log

    def self.init(path)
      @@path = path
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
