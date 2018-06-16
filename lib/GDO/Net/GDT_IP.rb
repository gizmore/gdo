#
# An IP is stored as textual representation.
#
class GDO::Net::GDT_IP < GDO::DB::GDT_String
  
  #######################
  ### Current user IP ###
  #######################
  def self.current(ip=nil)
    @@current ||= nil
    @@current = ip unless ip.nil?
    @@current || "127.0.0.1"
  end
  
  ###########
  ### GDT ###
  ###########
  def initialize
    super
    min(3)
    max(39)
    ascii
    ip6
  end
  
  # IPv6 support?
  def _ip6; @ip6; end
  def ip6(ip6=true); @ip6 = ip6; self; end
  
end
