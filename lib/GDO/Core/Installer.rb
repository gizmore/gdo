module GDO::Core
  class Installer
    
    extend ::GDO::Core::WithInstance
    
    def install_module(gdo_module)
      ::GDO::Core::Log.debug("GDO::Core::Installer.install_module #{gdo_module.name}")
    end
    
    
    
  end
end