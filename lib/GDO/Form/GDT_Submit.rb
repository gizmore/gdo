module GDO::Form
  class GDT_Submit < ::GDO::UI::GDT_Button
    
    def self.default_name; "submit"; end
    def default_label; t(:btn_submit); end
    
    ##############
    ### Render ###
    ##############
    def render_html; end

  end
end
