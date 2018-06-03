module GDO::Core
  class Exception < StandardError
    
    def initialize(message)
      super(message)
      @message = message
      ::GDO::Core::Log.exception(self)
    end
    
    def to_s
      "GDO::Core::Exception: #{@message}"
    end
    
  end
end
