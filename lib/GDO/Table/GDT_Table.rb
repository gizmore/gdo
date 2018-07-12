#
#
#
class GDO::Table::GDT_Table < GDO::Core::GDT
  
  ###########
  ### GDT ###
  ###########
  def _query; @query; end
  def query(query); @query = query; self; end
  
  def _result; @result||= query_result; end
  def result(result); @result = result; self; end
  
  ##############
  ### Render ###
  ##############

end
