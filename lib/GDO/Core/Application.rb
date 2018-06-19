class GDO::Core::Application
  
  extend ::GDO::Core::WithEvents

  def self.init
  end


  def initialize
  end
  
  #############
  ### HTTPD ###
  #############
  def self.call(env)
    byebug
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
  #
  # Flush every cache and reload all classes code at runtime.
  #
  def self.reload_gdo
    # Clear
    clear_cache

    # Clear events. they will be rehooked
    ::GDO::Core::WithEvents.class_variable_set(::GDO::Core::WithEvents::EVENT_KEY, {})

    # Reload code
    ::GDO::Core::Util.each_constant(::GDO) do |const|
      const.reload
    end
    # Reload modules
    ::GDO::Core::ModuleLoader.init
  end

end
