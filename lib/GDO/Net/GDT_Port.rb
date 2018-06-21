module GDO::Net
  class GDT_Port < ::GDO::DB::GDT_UInt

    def initialize(name=nil)
      super
      min(1)
      max(65535)
      bytes(2)
    end

  end
end