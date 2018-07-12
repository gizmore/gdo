#
#
#
class GDO::Test::Helper

  # request helper
  def first_gdo_request(query={})
    cookie = ::GDO::User::GDO_Session::MAGIC_VALUE
    gdo_request("GET", query, cookie)
  end

  def next_gdo_request(method, query={})
    cookie = ::GDO::Core::Application.cookie(::GDO::User::GDO_Session::COOKIE_NAME)
    gdo_request(method, query, "gdor=#{cookie}")
  end

  def gdo_request(method, query, cookie)
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
