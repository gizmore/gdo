#
#
#
class GDO::Method::Base
  
  include ::GDO::Core::WithEvents
  extend ::GDO::Core::WithInstance
  # include ::GDO::Core::WithName
  
  def parameters; []; end
  def permission; end
  def module_name; self.class.name.split('::')[-3]; end
  def gdo_module; get_module(module_name); end
  def method_name; self.class.name.split('::')[-1]; end
  
  def initialize
    @parameters = parameters
  end
  
  def parameter(field)
    field = field.to_s
    @parameters.each{|param|return param if param._name == field}
    raise ::GDO::Core::Exception.new(t(:err_unknown_method_parameter, name, field))
  end
  
  #
  # Wrapping execution here.
  # You override only "execute".
  #
  def execute_method
    begin
      execute

    # Own exceptions have a code
    rescue GDO::Core::Exception => e
      ::GDO::Method::GDT_Response.make_with(
        ::GDO::UI::GDT_Error.make_with_exception(e),
      ).code(e.code)
    # Ruby exceptions are 500
    rescue => e
      ::GDO::Method::GDT_Response.make_with(
        ::GDO::UI::GDT_Error.make_with_exception(e),
      ).code(500)
    end
  end
  
  def execute
    raise ::GDO::Core::Exception.new(t(:err_execute_stub))
  end
  
  #
  # A response with a success message
  #
  def response_success(text)
    ::GDO::Method::GDT_Response.make_with(
      ::GDO::UI::GDT_Success.new.text(text),
    )
  end
  
  #
  # Set gdt#@vars
  #
  def set_parameters(vars)
    ::GDO::Core::Log.debug("GDO::Method::Base#set_parameters()")
    @parameters.each{|gdt| gdt.vars(vars) }
    self
  end
  
  def response_with(*gdts)
    ::GDO::Method::GDT_Response.make_with(*gdts)
  end
  
end
