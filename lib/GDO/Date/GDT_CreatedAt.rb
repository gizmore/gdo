module GDO::Date
  class GDT_CreatedAt < GDT_Timestamp
    
    # Not null by default
    def initialize
      super
      not_null
    end
    
    # Fixed not null
    def _not_null; true; end
    
    # Fixed column definition
    def column_define; "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"; end

  end
end
