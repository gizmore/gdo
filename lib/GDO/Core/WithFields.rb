#
#
#
module GDO::Core::WithFields

  def fields
    []
  end

  def with_fields(fields)
    @fields = fields
    self
  end
  
  def _fields
    @fields ||= fields
  end
  
  
  def add_field(field)
    _fields.push(field)
    self
  end
  
  def add_fields(*fields)
    _fields << fields
    self
  end

  def field(field)
    _fields.each{|gdt| return gdt if gdt._name == field.to_s }
    raise ::GDO::Core::Exception.new(t(:err_unknown_field, field, self.class.name))
  end

  def set_var(field, var)
    self.field(field).var(var) and self
  end

  def set_value(field, value)
    self.field(field).value(value) and self
  end

  def get_var(field)
    self.field(field)._var
  end

  def get_value(field)
    self.field(field)._value
  end
  
  def fields_of(klass)
    _fields.select{|gdt|
      gdt.is_a?(klass)
    }
  end
  
end
