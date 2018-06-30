class GDO::Form::GDT_Hidden < GDO::Core::GDT

  def initialize
    super
    not_null
  end
  
  def render_form; ::GDO::Core::GDT_Template.render_template('Form', 'form/gdt_hidden.erb', {:field => self}); end

end
