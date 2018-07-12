#
#
#
class GDO::Date::GDT_Timestamp < GDO::DB::GDT_DBField
  
  ##########
  ### DB ###
  ##########
  def column_define; "TIMESTAMP #{column_define_null} #{column_define_default}"; end

  #############
  ### Value ###
  #############
  def to_var(value)
    value.to_s
  end
  
  def to_value(var)
    DateTime.parse(var)
  end
  
end
