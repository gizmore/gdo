require 'json'
#
#
#

class GDO::DB::GDT_JSON < GDO::Core::GDT
  def to_var(value)
    JSON.generate(value)
  end
  def to_value(var)
    JSON.parse(var)
  end
end