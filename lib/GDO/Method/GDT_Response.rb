module GDO::Method
  class GDT_Response < ::GDO::Core::GDT
    
    include ::GDO::Core::WithFields
    
    def self.make_with(*gdts)
      instance = new
      gdts.each{|gdt| instance.add_field(gdt) }
      instance
    end
    
    ###########
    ### GDT ###
    ###########
    def initialize(name=nil)
      super
      @code = 200
    end
    
    def _code; @code; end 
    def code(code); @code = code; self; end
    
    def _exception; _fields[0]._exception; end
    
  end
end
