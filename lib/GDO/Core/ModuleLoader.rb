module GDO::Core
  class ModuleLoader
    extend ::GDO::Core::WithInstance

    def initialize
      @modules = {}
    end

    def add_module(mod)
      mod.class.instance_set(mod)
      @modules[mod.name] = mod
    end
    
    def self.init
      instance.init_modules
      instance.load_module_vars rescue nil
      instance.inited_modules
    end
    
    def init_modules
      @modules.each {|name, mod|
        ::GDO::Core::Log.info("loading module #{name}")
        mod.on_load_language
      }
    end

    def load_module_vars
      result = ::GDO::Core::GDO_ModuleVar.table.select.join_object('mv_module').select('module_name').execute
      while mv = result.fetch_object
        @modules[mv.get_var('module_name')].set_config_var(mv.get_var('mv_key'), mv_get_var('mv_value'))
      end
    end

    def inited_modules
      @modules.each {|name, mod|
        mod.after_init
      }
    end

  end
end