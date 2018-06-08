module GDO::Date
  class GDT_CreatedAt < GDT_Timestamp
    
    def column_define; "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"; end

  end
end
