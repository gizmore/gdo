#
#
#
class GDO::Form::GDT_Select < GDO::Form::GDT_ComboBox
  
  def initialize(name=nil)
    super
    @multiple = false
  end

  ###########
  ### GDT ###
  ###########
  def multiple(multiple=true); @multiple = multiple; self; end
  def _multiple; @multiple; end

  def to_value(var)
    var.split(',')
  end

  def to_var(value)
    value.join(',')
  end

  ##############
  ### Render ###
  ##############
  def render_form; ::GDO::Core::GDT_Template.render_template('Form', 'form/gdt_select.erb', {:field => self}); end

end
