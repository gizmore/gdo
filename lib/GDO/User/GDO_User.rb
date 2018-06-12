module GDO::User

  #
  # The holy user entity.
  #
  # Currently it holds:
  # user_type (ghost,bot,guest,member)
  # user_name, user_guest_name, user_real_name
  # user_display_name (is created from the 3 names)
  # user_created_at
  #
  # @since 1.00
  # @version 1.00
  # @see ::GDO::Core::GDO
  # @see ::GDO::User::GDT_Username
  #
  # @author gizmore@wechall.net
  #
  class GDO_User < ::GDO::Core::GDO

    # @return [::GDO::Core::GDT]
    def fields
      [
          ::GDO::DB::GDT_AutoInc.make(:user_id),
          ::GDO::User::GDT_UserType.make(:user_type),
          ::GDO::Mail::GDT_Email.make(:user_email).unique,
          ::GDO::User::GDT_Username.make(:user_name).unique, # It has a unique login name
          ::GDO::User::GDT_Username.make(:user_guest_name), # it can have a guest name for guests
          ::GDO::DB::GDT_String.make(:user_real_name), # it can have a real name as well
          ::GDO::DB::GDT_String.make(:user_display_name), # is set to display name for search etc
          ::GDO::Date::GDT_CreatedAt.make(:user_created_at)
      ]
    end

  end
end
