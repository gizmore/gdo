#
# 
#
class GDO::Method::QueryTable < GDO::Method::Base

  #################
  ### Overrides ###
  #################  
  def query; nil; end
  def paginated?; true; end
  def filtered?; true; end
  def ordered?; true; end
  
  def table_columns; query._gdo.columns.values; end
  
  def parameters
    params = []
    params.push(::GDO::Table::GDT_PageMenu.new(:page)) if paginated?
    params.push(::GDO::Table::GDT_TableOrder.new(:order).table(_table)) if ordered?
    params.push(::GDO::Table::GDT_TableFilter.new(:filter).table(_table)) if filtered?
    params
  end
  
  #
  def _table; @table ||= ::GDO::Table::GDT_Table.new(:table).with_fields(table_columns); end
  def _pagemenu; parameter(:page); end
  def _order; parameter(:order); end
  def _filter; parameter(:filter); end

  ############
  ### Exec ###
  ############
  def execute
    
    # Query
    query = self.query

    # Pagemenu
    if paginated?
      _pagemenu.limit(pagemenu_limit)
      _pagemenu.query(query)
      _response.add_field _pagemenu
    end
    
    # Table
    table = _table
    table.query(query)
    table.filtered(filtered?)
    table.ordered(ordered?)
    _response.add_field table 
    
  end
  
  def pagemenu_limit
    ::GDO::Table::Module.instance.cfg_user_ipp
  end

end
