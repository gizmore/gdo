#
#
#
class GDT::UI::GDT_Box < GDT::Core::GDT
  
  include ::GDO::Core::WithFields
  
  HORIZONTAL = 1
  VERTICAL = 2
  def _orientation; @orientation||=HORIZONTAL; end
  def orientation(orientation); @orientation = orientation; self; end
  def vertical; orientation(VERTICAL); end
  def horizontal; orientation(HORIZONTAL); end
  def horizontal?; @orientation == HORIZONTAL; end
  
  def render_html; render_template('gdt_box.erb'); end
  
end
