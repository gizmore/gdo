module GDO::User

  #
  # The holy user entity
  #
  # @since 1.0
  # @version 6.00
  # @see ::GDO::Core::GDO
  class GDO_User < ::GDO::Core::GDO


    # @return [::GDO::Core::GDT]
    def fields
      [
          ::GDO::DB::GDT_AutoInc.make(:user_id),
          ::GDO::User::GDT_Username.make(:user_name).unique.not_null,
          ::GDO::Mail::GDT_Email.make(:user_email).unique,
      ]
    end

  end
end
