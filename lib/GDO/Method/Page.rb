#
# Simple page rendering.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Method::Page < GDO::Method::Base
  
  def execute
    gdt = ::GDO::Core::GDT_Template.new.
      tmod(module_name).
      tpath("page/#{method_name.downcase}.erb").
      tvar("response", _response)
    page_template(gdt)
    _response.add_field(gdt)
  end

  def page_template(gdt_template)
  end
  
end
