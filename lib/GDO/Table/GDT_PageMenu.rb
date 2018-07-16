#
#
#
class GDO::Table::GDT_PageMenu < GDO::Core::GDT
  
  def _max_limit; @max_limit || 100; end
  def max_limit(max); @max_limit = max; self; end
  
  def _limit; @limit; end
  def _from; 0; end

  def _page; @page || 1; end
  def page(page); @page = Page; self; end

  def _query; @query; end
  def query(query)
    @query = query
    query.limit(_limit, _from)
    self
  end
  
  def var(var)
    unless var.nil?
      @page = var.substr_to(',', @var)
      @limit = var.substr_from(',', 20)
    end
    super
  end
  
end
