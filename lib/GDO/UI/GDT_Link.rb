class GDO::UI::GDT_Link < GDO::UI::GDT_Anchor
  
  def render_html; ::GDO::Core::GDT_Template.render_template('UI', 'gdt_link.erb', field: self); end

end
