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
  
  def self.current_form
    Thread.current[:gdo_form]
  end
 
  ################
  ### Validate ###
  ################
  def validate_form
    Thread.current[:gdo_form] = self # ugly but gdt validator needs this.
    error_count = 0
    _fields.each do |gdt|
      error_count += 1 unless gdt.validate(gdt._value)
    end
    error_count == 0 ? true : error(t(:err_form_has_errors, error_count))
  end
  
  def has_errors?; count_errors > 0; end

  def count_errors
    count = 0
    _fields.each do |gdt|; count += 1 if gdt.has_error?; end
    count
  end
  
  def validate(value)
    return true if validate_form
    error(t(:err_form_has_errors, count_errors))
  end
  
  ##############
  ### Values ###
  ##############
  def get_vars
    data = {}
    _fields.each do |gdt|
      data[gdt._name] = gdt._var
    end
    data
  end
  
  ##############
  ### Render ###
  ##############
  def render_html; ::GDO::Core::GDT_Template.render_template('Form', 'form/gdt_form.erb', {:field => self}); end
  
end
