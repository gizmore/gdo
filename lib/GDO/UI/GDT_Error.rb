class GDO::UI::GDT_Error < GDO::UI::GDT_Label
  def self.make_with_exception(exception)
    ::GDO::Core::Log.exception(exception)
    trace = exception.backtrace
    trace = trace ? trace.join("\n") : ''
    make.text(exception.to_s+"\n"+trace)
  end
end
