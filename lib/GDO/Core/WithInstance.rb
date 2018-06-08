module GDO::Core::WithInstance

  def instance
    if class_variable_defined?('@@gdo_instance')
      class_variable_get('@@gdo_instance')
    else
      instance = self.new
      instance_set(instance)
    end
  end
  
  def instance_set(instance)
    class_variable_set('@@gdo_instance', instance)
    instance
  end

end
