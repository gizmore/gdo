module GDO::DB
  class GDT_Select < ::GDO::Core::GDT
    
    def initialize
      super
      @multiple = false
      @choices = {}
    end

    ###########
    ### GDT ###
    ###########
    def multiple(multiple=true); @multiple = multiple; self; end
    def _multiple; @multiple; end

    def _choices; @choices; end
    def choices(choices); @choices = choices; self; end
    def init_choices; choices({}); end

    ##############
    ### Render ###
    ##############
    def render_form
      ::GDO::Core::GDT_Template.render_template('DB', 'form/select.erb', :field => self)
    end

  end
end
