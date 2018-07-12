#
# Use this GDT to add additional validators to forms.
# A validator operates on a field and calls a func on an object(method)
#
# @version 1.00
# @since 1.00
# @author gizmore@wechall.net
# @license MIT
#
# @see GDT_Error, GDT_Success
#
class GDO::Form::GDT_Validator < GDO::Core::GDT
  
  def initialize(name=nil)
    super
    @validator_field = nil # field to decorate
    @validator_method = nil # object to call
    @validator_func = nil # func to call on object
  end
  
  def validator(field, method, func)
    @validator_field = field
    @validator_method = method
    @validator_func = func
    self
  end
  
  ################
  ### Validate ###
  ################
  def validate(value)
    form = ::GDO::Form::GDT_Form.current_form
    field = form.field(@validator_field)
    @validator_method.send(@validator_func, form, field)
  end
  
end
