module GDO::Core
  class GDO_ModuleVar < ::GDO::Core::GDO

    include ::GDO::Core::IsModule
    extend ::GDO::Core::WithInstance

    def self.inherited(klass)
      puts klass
    end

    def gdo_columns
      [
      ::GDO::Core::GDT_Module.make('mv_module').primary,
      ::GDO::DB::GDT_String('mv_key').primary,
      ::GDO::DB::GDT_String('mv_value').primary,
      ]
    end

    def self._path; @path; end
    def self.path(path); @path = path; self; end

    def self.provides_theme(theme)
      ::GDO::Core::GDT_Theme.designs[theme] = _path
    end

  end
end
