class GDO::Form::GDT_Submit < GDO::UI::GDT_Button
  
  def default_name; "submit"; end
  def default_label; t(:btn_submit); end
  
  ##############
  ### Render ###
  ##############
  def render_form; ::GDO::Core::GDT_Template.render_template('Form', 'form/gdt_submit.erb', {:field => self}); end

end
