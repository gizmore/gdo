module GDO::DB
  class GDT_Select < ::GDO::Core::GDT

    def choices(choices); @choices = choices; self; end
    def _choices; @choices; end

    def init_choices
      choices({})
    end

    def render_form
      ::GDO::Core::GDT_Template.render_template('DB', 'form/select.erb', :field => self)
    end

  end
end