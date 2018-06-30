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
  
  ##############
  ### Config ###
  ##############
  def module_config
    [
        ::GDO::Core::GDT_Theme.new('theme').initial('default'),
    ]
  end

  def cfg_themes; config_value('theme'); end
  
  subscribe(:gdo_include_assets, 'gdo-core-assets') do
    page = ::GDO::UI::GDT_WebPage.instance
    instance.add_js('gdo.js')
    instance.add_css('gdo.css')
    # page.favicon()
  end

end
