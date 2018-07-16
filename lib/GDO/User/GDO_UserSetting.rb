#
#
#
class GDO::User::GDO_UserSetting

  def fields
    [
      ::GDO::User::GDT_User(:uset_user).primary.not_null,
      ::GDO::Core::GDT_Module(:uset_module).primary.not_null,
      ::GDO::DB::GDT_Name(:uset_key).primary.not_null,
      ::GDO::DB::GDT_String.new(:uset_value),
    ]
  end

end
