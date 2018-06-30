#
#
#
class GDO::UI::GDT_Success < GDO::UI::GDT_Label
  
  def render_html; ::GDO::Core::GDT_Template.render_template('UI', 'gdt_success.erb', field: self); end

end
