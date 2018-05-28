module GDO::DB
  class GDT_Name < ::GDO::DB::GDT_String
    def initialize
      super
      @min = 2
      @max = 32
      @pattern = "/[a-z][-a-z_0-9]{1,31}/"
      @case_i = false
    end
  end
end