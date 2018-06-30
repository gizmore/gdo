module GDO::Core
  class GDT_Theme < ::GDO::Form::GDT_Select

    def self.designs; @@designs ||= {}; end
    
    def init_choices
      @choices = @@designs;
    end


  end
end
