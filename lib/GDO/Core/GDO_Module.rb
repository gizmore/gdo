module GDO::Core
  class GDO_Module < ::GDO::Core::GDO

    include ::GDO::Core::IsModule
    extend ::GDO::Core::WithInstance
    
    # def self.inherited(klass)
      # puts klass
    # end

    def gdo_columns
      [
          GDO::DB::GDT_AutoInc.make('module_id'),
          GDO::DB::GDT_Name.make('module_name'),
          GDO::DB::GDT_Version.make('module_version'),
          GDO::File::GDT_Path.make('module_path'),
          GDO::DB::GDT_Boolean.make('module_enabled'),
      ]
    end

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

    ###############
    ### Install ###
    ###############
    def install
      # ::GDO::Core::Installer.instance.install_module(self)
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
    end

    def config_var(field)
      module_config_var(field)._var
    end

    def config_value(field)
      module_config_var(field)._value
    end



    def user_config
      []
    end

    def user_settings
      []
    end



  end
end
