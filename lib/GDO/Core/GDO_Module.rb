module GDO::Core
  class GDO_Module < ::GDO::Core::GDO

    include ::GDO::Core::IsModule
    extend ::GDO::Core::WithInstance
    
    def table_name; "gdo_module"; end

    def fields
      [
          ::GDO::DB::GDT_AutoInc.make('module_id'),
          ::GDO::DB::GDT_Name.make('module_name').not_null.case_s,
          ::GDO::DB::GDT_Version.make('module_version').not_null.initial('1.00'),
          ::GDO::DB::GDT_Boolean.make('module_enabled').not_null.initial('1'),
      ]
    end

    def module_name; self.class.name.split('::')[-2]; end
    def module_package; self.class.name.substr_from('::').substr_from('::'); end
    def module_version; get_var('module_version'); end
    def module_enabled; get_var('module_enabled'); end
    
    def self._path; @path; end
    def self.path(path); @path = path; self; end

    def self.provides_theme(theme)
      ::GDO::Core::GDT_Theme.designs[theme] = _path
    end
    
    # Language
    def on_load_language; end
    def load_language(path)
      ::GDO::Lang::Trans.instance.add_path("#{@path}/#{path}")
      self
    end
    
    def tables; []; end
    def version; 1.0; end
    def default_enabled; true; end

    ###############
    ### Install ###
    ###############
    def after_install
    end
    
    def after_init
    end

    ##############
    ### Config ###
    ##############
    def module_config
      []
    end

    def module_config_var(field)
      module_config.each {|gdt|
        return gdt if gdt._name == field.to_s
      }
      raise ::GDO::Core::Exception.new(t(:err_unknown_config, field))
      nil
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

    def set_config_var(field, value)
      module_config_var(field).value(value)
      self
    end
    
    def save_config_var(field, var)
      ::GDO::Core::GDO_ModuleVar.blank(
      mv_module: self.get_id,
      mv_key: field,
      mv_value: var,
      ).replace
      set_config_var(field, var)
    end

    def save_config_value(field, value)
      save_config_var(field, column(field).to_var(value))
    end


    def user_config
      []
    end

    def user_settings
      []
    end



  end
end
