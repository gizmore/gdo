#
#
#
class GDO::User::GDT_CreatedBy < GDO::User::GDT_User
  
  def before_create(gdo, query)
    
    user = ::GDO::User::GDO_User.current
    
    gdo.set_var(_name, user)
    
  end
  
end
