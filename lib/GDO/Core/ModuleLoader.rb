module GDO::Core
  class ModuleLoader
    extend ::GDO::Core::WithInstance

    def initialize
      @modules = {}
    end

    def add_module(mod)
      @modules[mod.name] = mod
    end
    
    def self.init
      instance.init_modules
      instance.load_module_vars
    end
    
    def init_modules
      @modules.each {|name, mod|
        puts name
        mod.on_load_language
      }
    end

    def load_module_vars

      @modules.each_with_index {|k, v| puts k}

    end

  end
end