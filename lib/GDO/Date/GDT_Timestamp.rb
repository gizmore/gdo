module GDO::Date
  class GDT_Timestamp < ::GDO::Core::GDT
    
    def to_var(value)
      value.to_s
    end
    
    def to_value(var)
      DateTime.parse(var)
    end
    
    def column_define; "TIMESTAMP #{column_define_null} #{column_define_default}"; end


  end
end
