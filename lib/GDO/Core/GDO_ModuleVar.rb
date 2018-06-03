module GDO::Core
  class GDO_ModuleVar < ::GDO::Core::GDO
    
    def gdo_columns
      [
      ::GDO::Core::GDT_Module.make('mv_module').primary,
      ::GDO::DB::GDT_String('mv_key').primary,
      ::GDO::DB::GDT_String('mv_value').primary,
      ]
    end

  end
end
