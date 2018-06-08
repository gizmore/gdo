module GDO::Core
  class GDO_ModuleVar < ::GDO::Core::GDO
    
    def fields
      [
      ::GDO::Core::GDT_Module.make('mv_module').primary.not_null,
      ::GDO::DB::GDT_String.make('mv_key').primary.not_null,
      ::GDO::DB::GDT_String.make('mv_value'),
      ]
    end

  end
end
