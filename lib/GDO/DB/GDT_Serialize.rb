#
# Use ruby marshaller to serialize ruby objects into a database.
#
# @see ::GDO::User::GDO_Session
#
class GDO::DB::GDT_Serialize < GDO::DB::GDT_Text
  
  def to_var(value)
    Marshal.dump(value)
  end
  
  def to_value(var)
    return nil if var.nil?
    Marshal.load(var)
  end
  
end
