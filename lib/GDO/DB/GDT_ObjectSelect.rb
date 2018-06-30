#
#
#
class GDO::DB::GDT_ObjectSelect < ::GDO::Form::GDT_Select
  
  include ::GDO::DB::WithObject

  def initialize(make=nil)
    super
  end
  
  def init_choices
    byebug
  end

end
