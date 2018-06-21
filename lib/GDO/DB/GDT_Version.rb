module GDO::DB
  class GDT_Version < GDT_Decimal
    
    def initialize(name=nil)
      super
      digits(3,2)
    end

  end
end
