class GDO::User::GDO_UserPermission < GDO::Core::GDO
  def fields
    [
      ::GDO::User::GDT_User.make(:up_user).not_null.primary,
      ::GDO::DB::GDT_Object.make(:up_permission).table(::GDO::User::GDO_Permission).not_null.primary,
      ::GDO::Date::GDT_CreatedAt.make(:up_created),
      ::GDO::User::GDT_CreatedBy.make(:up_creator),
    ]
  end
end