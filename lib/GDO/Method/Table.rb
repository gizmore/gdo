#
#
#
class GDO::Method::Table < GDO::Method::Base
  
  def execute
    
    table = ::GDO::Table::GDT_Table.new
    
    _response.add_field table 
    
  end
  
end