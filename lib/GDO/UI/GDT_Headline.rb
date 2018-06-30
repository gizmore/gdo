#
#
#
class GDO::UI::GDT_Headline < GDO::UI::GDT_Label
  
  def _level; @level ||= 3; end
  def level(level); @level = level; self; end;
  
  def render_html; render_template('gdt_headline.erb'); end
  
end
