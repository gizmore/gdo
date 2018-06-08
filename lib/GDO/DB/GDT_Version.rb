module GDO::DB
  class GDT_Version < GDT_Decimal
    
    def initialize()
      super
      digits(3,2)
    end

  end
end
