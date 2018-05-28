module GDO::User
  class GDO_User < ::GDO::Core::GDO

    def fields
      [
          ::GDO::DB::GDT_AutoInc.make(:user_id),
          ::GDO::User::GDT_Username.make(:user_name).unique,
      ]
    end

  end
end