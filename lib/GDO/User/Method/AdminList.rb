#
#
#
class GDO::User::Method::AdminList < GDO::Method::QueryTable
  
  def permission; :admin; end
  
  def query
    ::GDO::User::GDO_User.table.select
  end
  
end
