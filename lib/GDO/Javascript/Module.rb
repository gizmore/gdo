#
#
#
class GDO::Javascript::Module < GDO::Core::GDO_Module

  def module_config
    [
      ::GDO::DB::GDT_Enum.new(:minify_js).enums(:no, :yes, :concat).initial(:no).not_null
    ]
  end
  def cfg_minify_js; config_var(:minify_js); end
  
end
