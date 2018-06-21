module GDO::Core
  class GDO_ModuleVar < ::GDO::Core::GDO
    
    def fields
      [
      ::GDO::Core::GDT_Module.new('mv_module').primary.not_null,
      ::GDO::DB::GDT_String.new('mv_key').primary.not_null,
      ::GDO::DB::GDT_String.new('mv_value'),
      ]
    end

  end
end
