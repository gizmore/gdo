module GDO::DB
  class GDT_AutoInc < GDO::DB::GDT_Int
    
    def initialize(name=nil)
      super
      unsigned
    end
    
    def column_define
      "INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT"
    end
    
    # After insert, give id to the gdo
    def after_create(gdo)
      id = ::GDO::DB::Connection.instance.insert_id
      not_dirty = false
      gdo.set_var(@name, id, not_dirty)
    end

  end
end
