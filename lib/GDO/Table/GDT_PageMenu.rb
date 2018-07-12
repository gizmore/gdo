#
#
#
class GDO::Table::GDT_PageMenu < GDO::Core::GDT
  
  def _page; @page; end
  def page(page); @page = Page; self; end
end
