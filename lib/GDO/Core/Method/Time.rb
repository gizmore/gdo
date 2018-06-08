module GDO::Core::Method
  class Time < GDO::Method::Base
    
    def parameters
      [
        
      ]
    end
    
    def execute
      response_with(::GDO::Date::GDT_Datetime.make.value(Time.now))
    end
  end
end