#
# Prints server time. Merely a testing method.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Core::Method::Time < GDO::Method::Base

  def execute
    _response.add_field ::GDO::Date::GDT_Datetime.new.value(Time.now)
  end

end
