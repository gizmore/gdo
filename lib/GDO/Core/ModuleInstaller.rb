#
module GDO::Core
  #
  # @author gizmore@wechall.net
  # @version 1.00
  # @since 1.00
  #
  class ModuleInstaller
    
    extend ::GDO::Core::WithInstance
    
    def initialize
    end
    
    ###############
    ### Install ###
    ###############    
    # Install and update a module
    def install_module(mod)
      ::GDO::Core::Log.info "ModuleInstaller.install_module(#{mod.name})"
      
      # Install tables
      install_module_tables(mod)
      
      # copy db vars into old object
      if mod_db = ::GDO::Core::GDO_Module.table.get_by(module_name: mod.module_name)
        mod.set_vars(mod_db.get_vars)
        mod.persisted
      else
        mod = create_module(mod)
      end

      # put into cache      
      mod.recache
      ::GDO::Core::ModuleLoader.instance.add_module(mod)

      # updates
      update_module(mod)
      
      # Event
      mod.after_install
      
      self
    end
    
    #
    def install_module_tables(mod)
      mod.tables.each{|gdo|gdo.table.create_table}
    end
    
    #
    def create_module(mod)
      byebug
      mod.class.blank(
        module_name: mod.module_name,
        module_version: mod.version.to_s,
        module_enabled: mod.default_enabled ? '1' : '0',
      ).insert
    end

    ##############
    ### Update ###
    ##############
    def update_module(mod)
     version = mod.module_version.to_f
      while version < mod.version
        version += 0.01
        update_module_to(mod, version.to_s.gsub('.', '_'))
        mod.save_value(:module_version, version)
      end
    end
    
    def update_module_to(mod, version)
      klass = Object.const_get("#{mod.module_package}::Upgrade#{version}") rescue nil
      return false if klass.nil?
      klass.new.upgrade
      true
    end
    
    ############
    ### Drop ###
    ############
    def drop_module(mod)
      ::GDO::Core::Log.info "ModuleInstaller.drop_module(#{mod.module_name})"
      drop_module_tables(mod.delete)
    end
    
    def drop_module_tables(mod)
      mod.tables.each{|klass|klass.table.drop_table}
    end

  end
end
