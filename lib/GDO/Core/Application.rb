module GDO::Core
  class Application
    
    include ::GDO::Core::WithEvents

    def self.init
      
    end


    def initialize
      
    end
    
    def self.call(env)
    [200, {}, 'Hello World'+env.inspect]
    end
    
    def self.clear_cache
      ::GDO::Core::Log.info("GDO::Core::Application.clear_cache()")
      publish(:gdo_cache_flush)
    end


  end
end
