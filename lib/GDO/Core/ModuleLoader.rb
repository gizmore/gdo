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
      instance.load_module_vars #rescue nil
      instance.init_modules
      instance.inited_modules
    end
    
    def init_modules
      @modules.each {|name, mod|
        ::GDO::Core::Log.info("loading module #{name}")
        mod.on_load_language
      }
    end

    def load_module_vars
      result = ::GDO::Core::GDO_Module.table.select.where("module_enabled").execute
      while mod = result.fetch_assoc
        klass = Object.const_get("GDO::#{mod['module_name']}::Module") rescue nil
        if @modules[klass.to_s]
          klass.instance
          @modules[klass.to_s].set_vars(mod, false)
        end
      end
      
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
    
    #############
    ### Cache ###
    #############
    subscribe(:gdo_cache_flush) do
      instance
      ::GDO::Core::Util.each_class(::GDO) do |klass|
        byebug if klass.is_a?(::GDO::Core::GDO_Module)
        klass.instance if klass.is_a?(::GDO::Core::GDO_Module)
        
      end
    end
    
    # def flush
      # byebug
      # mods = @modules
      # @modules = {}
      # mods.each do |klass,mod|
        # byebug
        # klass.reload
      # end
    # end
#     

  end
end