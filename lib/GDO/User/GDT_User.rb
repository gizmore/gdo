module GDO::User
  class GDT_User < ::GDO::DB::GDT_Object
    
    def initialize(name=nil)
      super
      table(::GDO::User::GDO_User)
    end
    
  end
end
