#
#
#
class GDO::Method::Base < GDO::Core::GDT
  
  include ::GDO::Core::WithEvents
  # extend ::GDO::Core::WithInstance
  # include ::GDO::Core::WithName
  
  def parameters; []; end
  def permission; end
  def with_session?; true; end
  def user_type; end
  def _module; gdo_module(module_name); end
  def module_name; self.class.name.split('::')[-3]; end
  # def gdo_module; get_module(module_name); end
  def method_name; self.class.name.split('::')[-1]; end
  
  def _request; ::GDO::Core::Application.request; end
  # def request(request); @request = request; self; end
  
  def _response; ::GDO::Core::Application.response; end
  # def response(response); @response = response; self; end
  
  def initialize
    @parameters = parameters
  end
  
  def parameter(field)
    field = field.to_s
    @parameters.each{|param|return param if param._name == field}
    raise ::GDO::Core::Exception.new(t(:err_unknown_method_parameter, name, field))
  end
  
  def param_var(field); parameter(field)._var; end
  def param_value(field); parameter(field)._value; end
  
  def render_template(path, vars={})
    GDO::Core::GDT_Template.render_template(module_name, path, vars)
  end
  
  #
  # Wrapping execution here.
  # You override only "execute".
  #
  def execute_method
    session_start if with_session?
    execute
    _response
    rescue GDO::Core::Exception => e
      # Own exceptions have a code
      _response.add_field ::GDO::UI::GDT_Error.make_with_exception(e)
      _response.code(e.code)
      _response
    rescue => e
      # Ruby exceptions are 500
      _response.add_field ::GDO::UI::GDT_Error.make_with_exception(e)
      _response.code(500)
      _response
  end
  
  def execute
    raise ::GDO::Core::Exception.new(t(:err_execute_stub))
  end
  
  def success(message)
    _response.add_field ::GDO::UI::GDT_Success.new.text(message)
  end
  
  def error(message)
    _response.add_field ::GDO::UI::GDT_Error.new.text(message)
  end
  
  #
  # A response with a success message
  #
  # def response_success(text)
    # ::GDO::Method::GDT_Response.make_with(
      # ::GDO::UI::GDT_Success.new.text(text),
    # )
  # end
  
  #
  # Set gdt#@vars
  #
  def set_parameters(vars)
    ::GDO::Core::Log.debug("GDO::Method::Base#set_parameters()")
    @parameters.each{|gdt| gdt.vars(vars) }
    self
  end
  
  def session_start
    ::GDO::User::GDO_Session.start
  end
  
  # def response_with(*gdts)
    # ::GDO::Method::GDT_Response.make_with(*gdts)
  # end
  
end
