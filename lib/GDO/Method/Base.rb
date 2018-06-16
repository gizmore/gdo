module GDO::Method
  class Base
    
    include ::GDO::Core::WithEvents
    extend ::GDO::Core::WithInstance
    include ::GDO::Core::WithName
    
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
    
    def execute_method
      execute
    end
    
    def execute
      raise ::GDO::Core::Exception.new(t(:err_execute_stub))
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
end
