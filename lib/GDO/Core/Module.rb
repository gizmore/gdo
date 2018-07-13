class GDO::Core::Module < GDO::Core::GDO_Module

  is_module __FILE__
  provides_theme 'default'
  
  def version; 1.0; end
  def on_load_language; load_language('lang/core'); end

  def tables
    [
      GDO::Core::GDO_Module,
      GDO::Core::GDO_ModuleVar,
    ]
  end
  
  def on_load_assets
    add_js('js/gdo.js')
    add_css('css/gdo.css')
    add_asset('img/gdo_logo.png')
  end
  
  ##############
  ### Config ###
  ##############
  def module_config
    [
        ::GDO::Core::GDT_Theme.new('theme').initial('default'),
    ]
  end

  def cfg_themes; config_value('theme'); end

end
