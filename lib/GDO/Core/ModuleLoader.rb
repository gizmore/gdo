module GDO::Core
  class ModuleLoader
    extend ::GDO::Core::WithInstance

    def initialize
      @modules = {}
    end

    def add_module(mod)
      @modules[mod.name] = mod
    end

    def load_module_vars

      @modules.each_with_index {|k, v| puts k}

    end

  end
end