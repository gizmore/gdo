#
# Serve assets
#
class GDO::Core::Method::Asset < GDO::Method::Base
  
  def parameters
    [
      ::GDO::Core::GDT_Module.new(:mod).not_null,
      ::GDO::DB::GDT_Enum.new(:dir).enums(:js, :css, :img).not_null,
      ::GDO::DB::GDT_String.new(:file).not_null,
    ]
  end
  
  def execute
    mod = parameter(:mod)._value
    dir = parameter(:dir)._var
    file = parameter(:file)._var
    
  end
  
end