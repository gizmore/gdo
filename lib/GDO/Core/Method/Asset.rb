#
# Serve assets
#
# @example /?mo=Core&me=Asset&mod=Core&path=js/gdo.js
#
class GDO::Core::Method::Asset < GDO::Method::Base
  
  def parameters
    [
      ::GDO::Core::GDT_Module.new(:mod).not_null,
      ::GDO::DB::GDT_String.new(:path).not_null,
    ]
  end
  
  def execute
    mod = parameter(:mod)._value
    path = parameter(:file)._var
    full_path = mod.path_for(path)
    response.filestream(fullpath)
  end
  
end