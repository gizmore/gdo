#
# An error message in the UI.
# Knows how to render.
#
class GDO::UI::GDT_Error < GDO::UI::GDT_Label
  
  def _exception; @exception; end
  def exception(exception); @exception = exception; self; end
  def _code; @exception && @exception.code or 500; end
  
  def self.make_with_exception(exception, log=true)
    ::GDO::Core::Log.exception(exception) if log

    instance = new
    instance.exception(exception)
    
    trace = exception.backtrace
    trace = trace ? trace.join("\n") : ''
    
    instance.text(exception.to_s+"\n"+trace)
  end

end
