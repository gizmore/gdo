#
#
#
class GDO::Form::GDT_ComboBox < GDO::DB::GDT_String

  include ::GDO::Form::WithCompletion
  
  def initialize(name=nil)
    super
    @choices = {}
  end
  
  def _choices; @choices; end
  def choices(choices); @choices = choices; self; end
  def init_choices; choices({}); end

end
