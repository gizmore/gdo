module GDO::DB
  class GDT_UInt < ::GDO::DB::GDT_Int
    
    def initialize
      super
      @unsigned = true
    end

  end
end
