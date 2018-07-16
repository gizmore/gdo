#
#
#
class GDO::Table::GDT_Table < GDO::Core::GDT
  
  include ::GDO::Core::WithFields
  
  ###########
  ### GDT ###
  ###########
  def _query; @query; end
  def query(query); @query = query; self; end
  
  def _result; @result ||= query_result; end
  def result(result); @result = result; self; end
  
  def _ordered; @ordered||false; end
  def ordered(ordered=true); @ordered = ordered; self; end
  
  def _filtered; @filtered||false; end
  def filtered(filtered=true); @filtered = filtered; self; end
  
  ##############
  ### Render ###
  ##############
  def render_html
    ::GDO::Core::GDT_Template.render_template('Table', 'gdt_table.erb', field: self)
  end

  private

  def query_result
    return ::GDO::DB::ArrayResult.new([]) if @query.nil?
    @query.execute
  end
  
end
