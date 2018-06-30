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
    _response.add_field(
      ::GDO::Core::GDT_Template.new.
        tmod(module_name).
        tpath("page/#{method_name.downcase}.erb").
        tvar("response", _response)
    )
  end
end
