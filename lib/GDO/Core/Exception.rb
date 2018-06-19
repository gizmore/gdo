module GDO::Core
  class Exception < StandardError
    
    def initialize(message, code=500)
      super(message)
      @message = message
      @code = code
      ::GDO::Core::Log.exception(self)
    end
    
    def code=(code); @code = code; end
    def code; @code; end

    def to_s
      "GDO::Core::Exception: #{@message}"
    end
    
  end
end
