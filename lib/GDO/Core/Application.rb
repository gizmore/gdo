module GDO::Core
  class Application
    
    include ::GDO::Core::WithEvents

    def self.init
      
    end


    def initialize
      
    end
    
    #############
    ### HTTPD ###
    #############
    def self.call(env)
    [200, {}, 'Hello World'+env.inspect]
    end
    
    #############
    ### Cache ###
    #############
    def self.clear_cache
      ::GDO::Core::Log.info("GDO::Core::Application.clear_cache()")
      publish(:gdo_cache_flush)
    end

    ##############
    ### Reload ###
    ##############
    def self.reload_gdo
      # Clear
      clear_cache
      # Reload code
      ::GDO::Core::Util.each_constant(::GDO) do |const|
        const.reload
      end
      # Reload modules
      ::GDO::Core::ModuleLoader.init
    end


  end
end
