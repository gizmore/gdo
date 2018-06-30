#
#
#
class GDO::Install::GDT_InstallMenu < GDO::UI::GDT_Box
  
  def initialize(name=nil)
    super
    horizontal
    add_field ::GDO::UI::GDT_Link.make_href('Install', 'Welcome').label(t(:install_link_welcome))
    add_field ::GDO::UI::GDT_Link.make_href('Install', 'SystemCheck').label(t(:install_link_system_check))
  end
  
end
