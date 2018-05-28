module GDO::User
  class GDT_Username < ::GDO::DB::GDT_String

    def initialize()
      @min = 2
      @max = 31
      @pattern = /[a-z][-a-z_0-9]/i
    end


  end
end