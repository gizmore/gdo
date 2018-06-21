module GDO::Method
  class Form < Base
    
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
        return call_submit_func(gdt, form) if gdt._var == '1'
      }

      # No submit shows form
      response_with(form)
    end
    
    def call_submit_func(gdt, form)
      send("execute_#{gdt._name}")
    end
    
    def execute_submit
      raise ::GDO::Core::Exception.new(t(:err_form_stub_submit))
    end
    

  end
end
