#
#
#
class GDO::Form::GDT_Validator < GDO::Core::GDT
  
  def initialize(name=nil)
    super
    @validator_field = nil
    @validator_method = nil
    @validator_func = nil
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
    form = ::GDT::Form::GDT_Form.current_form
    field = form.field(@validator_field)
    @validator_method.call(@validator_func, form, field)
  end
  
end
