#
# An error message in the UI.
# Knows how to render.
# If there is an exception it renders a trace?
#
class GDO::UI::GDT_Error < GDO::UI::GDT_Label
  
  def _exception; @exception; end
  def exception(exception); @exception = exception; self; end
  def _code; @exception && @exception.code or 500; end
  
  def self.make_with_exception(exception, log=true)
    ::GDO::Core::Log.exception(exception) if log
    new.exception(exception).text(exception.to_s)
  end
  
  ##############
  ### Render ###
  ##############
  def render_html; ::GDO::Core::GDT_Template.render_template('UI', 'gdt_error.erb', field: self); end

end
