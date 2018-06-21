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
# @license MIT
# @author gizmore@wechall.net
#
# @see ::GDO::Core::GDO
# @see ::GDO::User::GDT_Username
#
class GDO::User::GDO_User < GDO::Core::GDO
  
  ###############
  ### Current ###
  ###############
  # @return [GDO::User::GDO_User]
  def self.current; Thread.current[:gdo_user] || ghost; end
  def self.current=(user); Thread.current[:gdo_user] = user; end
    
  ###########
  ### GDO ###
  ###########
  def fields
    [
      ::GDO::DB::GDT_AutoInc.new(:user_id),
      ::GDO::User::GDT_UserType.new(:user_type).initial(::GDO::User::GDT_UserType::MEMBER),
      ::GDO::Mail::GDT_Email.new(:user_email).unique,
      ::GDO::Crypto::GDT_PasswordHash.new(:user_password),
      ::GDO::User::GDT_Username.new(:user_name).unique, # It has a unique login name
      ::GDO::User::GDT_Username.new(:user_guest_name), # it can have a guest name for guests
      ::GDO::DB::GDT_String.new(:user_real_name), # it can have a real name as well
      ::GDO::DB::GDT_String.new(:user_display_name), # is set to display name for search etc
      ::GDO::Date::GDT_CreatedAt.new(:user_created_at)
    ]
  end
  
  def display_name
    html(get_var(:user_display_name)||get_var(:user_name))
  end

  ##############
  ### Helper ###
  ##############
  # @return self
  def get_by_login(login)
    login = quote(login)
    table.select.where("user_name=#{login} OR user_email=#{login}").first.execute.fetch_object
  end
  
  def find_by_name(user_name)
    table.select.where("user_name=#{quote(user_name)}").first.execute.fetch_object
  end
  
  #############
  ### Guest ###
  #############
  # @return [self]
  def self.ghost
    @@ghost ||= blank(
      user_type: ::GDO::User::GDT_UserType::GHOST,
      user_display_name: "~~~#{t(:ghost)}~~~",
    )
  end  
  
  ##################
  ### Permission ###
  ##################
  def load_permissions
    ::GDO::User::GDO_UserPermission.table.select('perm_name').join_object(:up_permission).where("up_user=#{get_id}").execute
  end
  def user_permissions
    @permissions ||= load_permissions
  end
  def has_permission?(permission_name)
    
  end

end
