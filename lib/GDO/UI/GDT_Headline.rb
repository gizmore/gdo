#
#
#
class GDO::UI::GDT_Headline < GDO::UI::GDT_Label
  
  def _level; @level ||= 3; end
  def level(level); @level = level; self; end;
  
  def render_html; ::GDO::Core::GDT_Template.render_template('UI', 'gdt_headline.erb', {:field => self}); end

end
