module GDO::DB
  class GDT_UInt < ::GDO::DB::GDT_Int
    
    def initialize(name=nil)
      super
      unsigned
    end

  end
end
