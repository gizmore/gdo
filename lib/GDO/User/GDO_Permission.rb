class GDO::User::GDO_Permission < GDO::Core::GDO
  
  def fields
    [
      ::GDO::DB::GDT_AutoInc.new(:perm_id),
      ::GDO::DB::GDT_Name.new(:perm_name).unique,
      ::GDO::Date::GDT_CreatedAt.new(:perm_created),
      ::GDO::User::GDT_CreatedBy.new(:perm_creator),
    ]
  end
  
end