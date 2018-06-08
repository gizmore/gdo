module GDO::Date
  class GDT_Datetime < GDT_Timestamp
    
    def column_define; "DATETIME #{column_define_null} #{column_define_default}"; end

    ###########
    ### GDT ###
    ###########    
    def to_var(value)
      value.to_s
    end
    
    def to_value(var)
      DateTime.parse(var)
    end

  end
end
