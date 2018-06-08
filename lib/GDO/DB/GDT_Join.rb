module GDO::DB
  class GDT_Join < ::GDO::Core::GDT
    
    def initialize
      super
      @join = "";
    end
    
    def _join; @join; end
    def join(join); @join += "#{join} "; self; end

    def column_define
      ""
    end
    
  end
end