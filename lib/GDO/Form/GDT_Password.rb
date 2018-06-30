class GDO::Form::GDT_Password < GDO::DB::GDT_String
  
  def default_label; t(:password); end
  
  def initialize(name=nil)
    super
    min(4)
    case_s
  end
  
  def render_form; ::GDO::Core::GDT_Template.render_template('Form', 'form/gdt_password.erb', {:field => self}); end

end