#
module GDO::Core
  #
  # Modules are autoloaded across installations.
  # Read DOC_CreateModules.md to learn about gdo modules.
  #
  # You can override the following methods
  # - tables: GDOs managed by your module
  # - version: This is the fs version of your module
  # - default_enabled: 
  # - after_install:
  # - after_init:
  #
  # @see ::GDO::Core::GDO
  # @see ::GDO::Core::ModuleLoader
  # @see ::GDO::Core::ModuleInstaller
  #
  # @see DOC_CreateModules.md
  # 
  # @version 1.00
  # @since 1.00
  # @author gizmore
  #
  class GDO_Module < ::GDO::Core::GDO

    include ::GDO::Core::WithEvents
    include ::GDO::Core::WithInstance
    extend ::GDO::Core::IsModule

    #################
    ### Overrides ###
    #################
    def version; 1.0; end
    def license; "MIT"; end
    def author; "gizmore@wechall.net"; end
    def tables; []; end
    def default_enabled; true; end
    def after_init; end
    def after_install; end
    def on_load_language; end

    ###########
    ### GDO ###
    ###########
    # Fixed table name
    def table_name; "gdo_module"; end 

    def fields
      [
        ::GDO::DB::GDT_AutoInc.new('module_id'),
        ::GDO::DB::GDT_Name.new('module_name').not_null.case_s,
        ::GDO::DB::GDT_Version.new('module_version').not_null.initial('1.00'),
        ::GDO::DB::GDT_Boolean.new('module_enabled').not_null.initial('1'),
        # Timestamps
        ::GDO::Date::GDT_EditedAt.new('module_updated'),
        ::GDO::Date::GDT_CreatedAt.new('module_created'),
      ]
    end

    def module_name; self.class.name.split('::')[-2]; end
    def module_version; get_var('module_version') || version; end
    def module_enabled; get_var('module_enabled') || default_enabled; end

    ###############
    ### Install ###
    ###############
    def install; ::GDO::Core::ModuleInstaller.instance.install_module self; end
    
    ###############
    ### Package ###
    ###############
    def module_package; self.class.module_package; end
    def module_package_name; self.class.module_package_name; end
    def self.module_package; ::Object.const_get(module_package_name); end
    def self.module_package_name; self.to_s.rsubstr_to('::'); end
    
    ############
    ### Path ###
    ############
    def _path; @path; end
    def path(path); @path = path; self; end

    #############
    ### Theme ###
    #############
    def self.provides_theme(theme)
      ::GDO::Core::GDT_Theme.designs[theme.to_s] = instance._path
    end
    
    ################
    ### Language ###
    ################
    def load_language(path)
      ::GDO::Lang::Trans.instance.add_path("#{@path}/#{path}")
      self
    end
    
    ###############
    ### Methods ###
    ###############
    #
    # @return [GDO::Method::Base]
    #
    def gdo_method(method_name)
      const_name = "GDO::#{module_name}::Method::#{method_name}"
      const = Object.const_get(const_name) or raise ::GDO::Core::Exception.new(t(:err_unknown_method, module_name, method_name))
      const.instance
    end
    

    ##############
    ### Config ###
    ##############
    #
    # The configuration variables of your module
    # 
    # @return [::GDO::Core::GDT]
    #
    def module_config
      []
    end
    
    def module_config_cache
      @module_config ||= module_config
    end

    def module_config_var(field)
      module_config_cache.each {|gdt|
        return gdt if gdt._name == field.to_s
      }
      raise ::GDO::Core::Exception.new(t(:err_unknown_config, module_name, field))
    end

    def config_var(field)
      module_config_var(field)._var
    end

    def config_value(field)
      module_config_var(field)._value
    end
    
    def set_config_var(field, var)
      module_config_var(field).var(var)
      self
    end

    def set_config_value(field, value)
      module_config_var(field).value(value)
      self
    end
    
    def save_config_var(field, var)
      raise ::GDO::Core::Exception.new("Cannot save config var #{field}. Module #{name} is not persisted.") unless persisted?
      ::GDO::Core::GDO_ModuleVar.blank(
      mv_module: get_id,
      mv_key: field,
      mv_value: var,
      ).replace
      set_config_var(field, var)
    end

    def save_config_value(field, value)
      save_config_var(field, column(field).to_var(value))
    end
    
    def delete_config_var(field)
      ::GDO::Core::GDO_ModuleVar.table.delete_query.where("mv_module=#{get_id}").execute
      module_config_var(field).reset
      self
    end

    ###################
    ### User config ###
    ###################
    def user_config
      []
    end

    def user_settings
      []
    end



  end
end
