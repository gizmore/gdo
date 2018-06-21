#
# A form has fields and renders them via `GDT.render_form` in their template.
#
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Form::GDT_Form <GDO::Core::GDT

  include ::GDO::Core::WithFields
  
  def render_html; render_template('form/gdt_form.erb'); end

end
