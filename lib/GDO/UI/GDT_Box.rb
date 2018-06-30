#
# A vertical or horizontal container.
# The themes should use flex to layout these.
# In CLI horizontal should be one line vs multiple lines in vertical mode.
#
class GDO::UI::GDT_Box < GDO::Core::GDT
  
  include ::GDO::Core::WithFields
  
  HORIZONTAL = 1
  VERTICAL = 2

  def _orientation; @orientation||=HORIZONTAL; end
  def orientation(orientation); @orientation = orientation; self; end
  def vertical; orientation(VERTICAL); end
  def horizontal; orientation(HORIZONTAL); end
  def vertical?; @orientation == VERTICAL; end
  def horizontal?; @orientation == HORIZONTAL; end
  
  def render_html; ::GDO::Core::GDT_Template.render_template('UI', 'gdt_box.erb', field: self); end
  
end
