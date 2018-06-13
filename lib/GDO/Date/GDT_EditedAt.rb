module GDO::Date
  class GDT_EditedAt < GDT_CreatedAt
    
    def column_define; "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"; end

  end
end
