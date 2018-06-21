class GDO::User::GDO_UserPermission < GDO::Core::GDO
  def fields
    [
      ::GDO::User::GDT_User.new(:up_user).not_null.primary,
      ::GDO::DB::GDT_Object.new(:up_permission).table(::GDO::User::GDO_Permission).not_null.primary,
      ::GDO::Date::GDT_CreatedAt.new(:up_created),
      ::GDO::User::GDT_CreatedBy.new(:up_creator),
    ]
  end
end