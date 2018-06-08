module GDO::DB
  class GDT_Boolean < ::GDO::DB::GDT_Select
    
    def column_define; "TINYINT(1) UNSIGNED #{column_define_null}#{column_define_default}"; end
    
  end
end
