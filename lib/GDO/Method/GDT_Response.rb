module GDO::Method
  class GDT_Response < ::GDO::Core::GDT
    
    include ::GDO::Core::WithFields
    
    def self.make_with(*gdts)
      instance = make
      gdts.each{|gdt| instance.add_field(gdt) }
      instance
    end
    
    ###########
    ### GDT ###
    ###########
    def initialize
      super
      @code = 200
    end
    
    def _code; @code; end 
    def code(code); @code = code; self; end
    
  end
end
