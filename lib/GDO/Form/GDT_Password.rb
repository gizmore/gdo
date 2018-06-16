class GDO::Form::GDT_Password < GDO::DB::GDT_String
  
  def initialize
    super
    min(4)
    case_s
  end
  
end