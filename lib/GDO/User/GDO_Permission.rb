class GDO::User::GDO_Permission < GDO::Core::GDO
  
  def fields
    [
      ::GDO::DB::GDT_AutoInc.make(:perm_id),
      ::GDO::DB::GDT_Name.make(:perm_name).unique,
      ::GDO::Date::GDT_CreatedAt.make(:perm_created),
      ::GDO::User::GDT_CreatedBy.make(:perm_creator),
    ]
  end
  
end