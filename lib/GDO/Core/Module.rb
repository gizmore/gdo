module GDO::Core
  class Module < ::GDO::Core::GDO_Module

    is_module __FILE__
    provides_theme 'default'
    
    def version; 1.0; end
    def on_load_language; load_language('lang/core'); end
    

    def tables
      [
        ::GDO::Core::GDO_Module,
        ::GDO::Core::GDO_ModuleVar,
      ]
    end
    
    def module_config
      [
          GDT_Theme.new('theme').initial('default'),
      ]
    end

    def cfg_theme; get_config_var('theme'); end

  end
end
