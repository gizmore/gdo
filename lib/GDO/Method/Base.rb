module GDO::Method
  class Base
    
    include ::GDO::Core::WithName
    
    def parameters; []; end
    
    def initialize
      @parameters = parameters;
    end
    
    def parameter(field)
      field = field.to_s
      @parameters.each{|param|return param if param.name == field}
    end
    
    def execute
      
    end
    
  end
end
