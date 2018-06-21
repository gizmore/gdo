module GDO::DB
  class GDT_Token < ::GDO::DB::GDT_String

    def initialize(name=nil)
      super
      @min = @max = 8
      @encoding = ASCII
      @case_i = false
    end

  end
end
