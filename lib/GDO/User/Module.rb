module GDO::User
  class Module < GDO::Core::GDO_Module

    is_module __FILE__
    
    def tables
      [
        ::GDO::User::GDO_User,
      ]
    end
    

  end
end
