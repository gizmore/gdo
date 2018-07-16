#
#
#
class GDO::Test::Helper

  ######################
  ### Request Helper ###
  ######################
  @@first = nil
  def self.do_gdo_request(mo, me, query={})
    query[:mo] = mo.to_s
    query[:me] = me.to_s
    if @@first.nil?
      @@first = true
      first_gdo_request(query)
    else
      next_gdo_request(query)
    end
  end
  
  def self.first_gdo_request(query={})
    cookie = ::GDO::User::GDO_Session::MAGIC_VALUE
    gdo_request("GET", query, cookie)
  end

  def self.next_gdo_request(method, query={})
    cookie = ::GDO::Core::Application.cookie(::GDO::User::GDO_Session::COOKIE_NAME)
    gdo_request(method, query, "gdor=#{cookie}")
  end
  
  private

  def self.gdo_request(method, query, cookie)
    query_string = ""
    query.each do |k,v|
      query_string += "&" unless query_string.empty?
      query_string += "#{k}=#{URI::encode(v)}"
    end
    env = {
      "METHOD" => method,
      "QUERY_STRING" => query_string,
      'COOKIE' => "gdor=#{cookie}",
    }
    ::GDO::Core::Application.call(env)
  end
  
end
