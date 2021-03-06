#
# ModuleLoader holds all module instances.
# Cache flush is handled by WithInstance decorator.
#
class GDO::Core::ModuleLoader
 
  extend ::GDO::Core::WithInstance

  def self.init
    instance.init
  end
  
  def initialize
    @modules = {}
  end

  ###############
  ### Factory ###
  ###############
  #
  # Called by `init_module __FILE__`
  #
  def add_module(mod)
    mod.class.instance_set(mod)
    @modules[mod.name] = mod
  end
  
  def get_modules
    @modules
  end
  
  def get_module(name)
    begin
      Object.const_get("::GDO::#{name}::Module").instance
    rescue
      raise ::GDO::Core::Exception.new(t(:err_module, name))
    end
  end

  ##############
  ### Loader ###
  ##############
  def init
    load_module_vars rescue nil
    init_modules
    inited_modules
  end
  
  private

  def init_modules
    @modules.each {|name, mod|
      ::GDO::Core::Log.info("loading module #{name}")
      mod.on_load_language
      mod.on_load_assets
      mod.tables
      mod.methods
    }
  end
  
  def inited_modules
    @modules.each {|name, mod|
      mod.after_init
    }
  end

  def load_module_vars
    
    result = ::GDO::Core::GDO_Module.table.select.where("module_enabled").execute
    while mod = result.fetch_assoc
      klass = Object.const_get("::GDO::#{mod['module_name']}::Module") rescue nil
      if klass
        @modules[klass.to_s] = klass.instance
        @modules[klass.to_s].set_vars(mod, false).persisted
      end
    end
    
    result = ::GDO::Core::GDO_ModuleVar.table.select.join_object('mv_module').select('module_name').execute
    while mv = result.fetch_assoc
      klass = Object.const_get("::GDO::#{mv['module_name']}::Module") rescue nil
      klass.instance.set_config_var(mv['mv_key'], mv['mv_value']) if klass
    end
    
  end

end
