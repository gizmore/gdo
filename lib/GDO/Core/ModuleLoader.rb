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
      instance = self.instance
      instance.load_module_vars rescue nil
      instance.init_modules
      instance.inited_modules
    end
    
    def init_modules
      @modules.each {|name, mod|
        ::GDO::Core::Log.info("loading module #{name}")
        mod.on_load_language
      }
    end
    
    def get_module(name)
      Object.const_get("::GDO::#{name}::Module").instance
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
      while mv = result.fetch_object
        klass = Object.const_get("::GDO::#{mv.get_var('module_name')}::Module") rescue nil
        klass.instance.set_config_var(mv.get_var('mv_key'), mv.get_var('mv_value')) if klass
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
    # subscribe(:gdo_cache_flush) do
      # byebug
      # instance
      # ::GDO::Core::Util.each_class(::GDO) do |klass|
        # byebug if klass.is_a?(::GDO::Core::GDO_Module)
        # klass.instance if klass.is_a?(::GDO::Core::GDO_Module)
      # end
    # end
    
    # def flush
      # mods = @modules
      # @modules = {}
      # mods.each do |klass,mod|
        # klass.reload
      # end
    # end
#     

  end
end