module GDO::Core
  class Module < ::GDO::Core::GDO_Module

    is_module __FILE__
    provides_theme 'default'

    def get_config
      [
          GDT_Theme.make('theme').initial('default'),
      ]
    end

    def cfg_theme; get_config_var('theme'); end

  end
end
