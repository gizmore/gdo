module GDO::Core
  class GDT_Module < ::GDO::DB::GDT_Object
    
    def initialize(name=nil)
      super
      @table = ::GDO::Core::GDO_Module.table
    end
    
  end
end
