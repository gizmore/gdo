#
#
#
class GDO::DB::GDT_Boolean < GDO::Form::GDT_Select
  
  def column_define; "TINYINT(1) UNSIGNED #{column_define_null}#{column_define_default}"; end
  
  def init_choices
    choices = _not_null ? { '' => t(:please_choose) } : {}
    choices['0'] = t(:no)
    choices['1'] = t(:yes)
    choices
  end

end
