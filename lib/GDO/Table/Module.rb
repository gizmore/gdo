#
# 
#
class GDO::Table::Module < GDO::Core::GDO_Module

  is_module __FILE__
  
  ##############
  ### Config ###
  ##############
  def module_config
    [
      ::GDO::DB::GDT_UInt.new(:table_ipp).max(1000).min(1).initial("20"),
      ::GDO::DB::GDT_UInt.new(:pager_maxlinks).max(100).min(0).initial("3"),
    ]
  end
  
  def cfg_table_ipp; module_config_value(:table_ipp); end
  def cfg_pager_links; module_config_value(:pager_maxlinks); end
  
  
end
