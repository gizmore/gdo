#
#
#
class GDO::Method::Form < GDO::Method::Base
  
  # def initialize
    # super
    # @form = nil
  # end

  def parameters
    get_form._fields
  end
  
  def pre_execute
    
  end
  
  def form(form)
    self
  end
  
  def get_form
    # cached
    return @form unless @form.nil?
    # make
    @form = ::GDO::Form::GDT_Form.new
    form(@form)
    # Call form hook
    publish("gdo_form_#{module_name.downcase}_#{method_name.downcase}", @form)
    # return
    @form
  end
  
  def execute
    
    # Build the form
    form = get_form
    
    # A submit calls execute_{action}
    form.fields_of(::GDO::Form::GDT_Submit).each{|gdt|
      return call_submit_func(gdt, form) if gdt._var
    }

    # No submit shows form
    _response.add_field form
  end
  
  def call_submit_func(gdt, form)
    
    if !form.validate_form
      form_invalid(form)
    else
      send("execute_#{gdt._name}", form)
    end
  end
  
  def execute_submit(form)
    raise ::GDO::Core::Exception.new(t(:err_form_stub_submit))
  end
  
  def form_invalid(form)
    _response.add_field form
  end

end
