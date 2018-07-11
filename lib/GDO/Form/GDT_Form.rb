#
# A form has fields and renders them via `GDT.render_form` in their template.
#
# @version 1.00
# @since 1.00
# @license MIT
# @author gizmore@wechall.net
#
class GDO::Form::GDT_Form <GDO::Core::GDT

  include ::GDO::Core::WithFields
  
  def render_html; ::GDO::Core::GDT_Template.render_template('Form', 'form/gdt_form.erb', {:field => self}); end
  
  def self.current_form
    Thread.current[:gdo_form]
  end
 
  def validate_form
    Thread.current[:gdo_form] = self
    valid = true
    _fields.each do |gdt|
      valid = false unless gdt.validate(gdt._value)
    end
    valid
  end

  def has_errors?
    _fields.each do |gdt|; return true if gdt.has_error?; end
    false
  end
  
  def form_data
    data = {}
    _fields.each do |gdt|
      data += hash_values
    end
    data
  end
  
end
