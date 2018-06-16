module GDO::User
  class GDT_User < ::GDO::DB::GDT_Object
    
    def initialize
      super
      table(::GDO::User::GDO_User)
    end
    
  end
end
