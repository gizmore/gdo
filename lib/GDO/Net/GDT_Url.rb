#
module GDO::Net
  #
  class GDT_Url < ::GDO::DB::GDT_String
    
    def initialize
      super
      case_s
    end
    
    
    def _reachable; @reachable; end
    def reachable(reachable=true); @reachable = reachable; self; end
    
    def _protocols; @protocols; end
    def protocols(*protocols); @protocols = protocols; self; end
    
  end
end
