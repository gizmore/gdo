#
# 
#
class GDO::Net::GDT_Url < ::GDO::DB::GDT_String

  def self.external_gdo_href(url)
    app = ::GDO::Core::Application
    protocol = app.http_protocol
    domain = app.http_domain
    port = app.http_port
    port = (port == "80") || (port == "443") || (port == "0") ? '' : ":#{port}"
    return "#{protocol}://#{domain}#{port}#{url}"
  end
    
  def initialize(name=nil)
    super
    case_s
    @reachable = false
    @protocols = ['http', 'https']
    @allow_local = false
  end
  
  def _reachable; @reachable; end
  def reachable(reachable=true); @reachable = reachable; self; end
  
  def _protocols; @protocols; end
  def protocols(*protocols); @protocols = protocols; self; end
  
  def _allow_local; @allow_local; end
  def allow_local(allow_local=true); @allow_local = allow_local; self; end
  
end
