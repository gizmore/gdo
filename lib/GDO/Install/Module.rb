#
#
#
class GDO::Install::Module < GDO::Core::GDO_Module
  
  is_module __FILE__
  
  def on_load_language; load_language("lang/install"); end

end
