#
# Session table.
# Uses rack cookies via ::GDO::Core::Application if no cookie is specified.
#
# @example
# session = ::GDO::User::GDO_Session.start
# session.set('key', 'value)
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
# @see GDO::Core::Application
# @see GDO::DB::GDT_Serialize
# @see GDO::User::GDO_User
#
class GDO::User::GDO_Session < GDO::Core::GDO
  
  COOKIE_NAME ||= 'gdor'
  MAGIC_VALUE ||= 'ilikecookies'
  
  ###########
  ### GDO ###
  ###########
  def engine; MYISAM; end # MyISAM allows faster writes than InnoDB

  def fields
    [
      ::GDO::DB::GDT_AutoInc.new('sess_id'),
      ::GDO::User::GDT_User.new('sess_user'),
      ::GDO::DB::GDT_Token.new('sess_token'),
      ::GDO::Net::GDT_IP.new('sess_ip'),
      ::GDO::Date::GDT_Timestamp.new('sess_timeout'),
      ::GDO::DB::GDT_Serialize.new('sess_data'),
    ]
  end
  
  def get_id; get_var('sess_id'); end
  def get_user; get_value('sess_user'); end
  def get_token; get_var('sess_token'); end
  def get_data; get_value('sess_data')||{}; end
  
  def cookie_data; "#{get_id}-#{get_token}"; end
  
  def self.set(key, value)
    instance.set(key, value)
  end
  
  def set(key, value)
    data = get_data
    data[key] = value
    save_value('sess_data', data)
  end
  
  def self.get(key)
    instance.get(key)
  end
  
  def get(key, default=nil)
    data = get_data
    return default if data[key].nil?
    data[key]
  end
  
  def self.remove(key)
    data = get_data
    data.delete(key)
    save_value('sess_data', data)
  end
    
  def self.get_cookie
    ::GDO::Core::Application.cookie(COOKIE_NAME)
  end
  
  def self.set_magic_cookie
    ::GDO::Core::Application.set_cookie(COOKIE_NAME, MAGIC_VALUE)
    new_instance
  end
    
  def self.instance
    ::Thread.current[:gdo_session] ||= blank
  end
  
  def self.new_instance
    ::Thread.current[:gdo_session] = nil
    instance
  end
    
  def self.start(cookie=nil)
    cookie = get_cookie if cookie.nil?
    return set_magic_cookie if cookie.nil?
    return new_session if cookie == MAGIC_VALUE
    return load_session(cookie)
    rescue ::GDO::Core::Exception
      return new_instance
    rescue => e
      ::GDO::Core::Log.exception(e)
      byebug
  end
  
  private
  
  def self.new_session
    instance = new_instance
    instance.save
    ::GDO::Core::Application.set_cookie(COOKIE_NAME, instance.cookie_data)
    instance
  end
  
  def self.load_session(cookie)
    id, token = cookie.split('-')
    instance = table.find(id)
    return new_session if instance.nil? || (instance.get_token != token)
    instance
  end
  
end
