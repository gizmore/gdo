module GDO::Date
  class GDT_Time < GDT_Timestamp

    def column_define; "TIME #{column_define_null} #{column_define_default}"; end
    
    def to_var(value)
      value.to_s
    end
    
    def to_value(var)
      Time.parse(var)
    end

  end
end
